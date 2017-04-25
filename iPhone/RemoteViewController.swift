//
//  ViewController.swift
//  iPhone
//
//  Created by Connery, Courtney on 4/18/17.
//  Copyright © 2017 Connery, Courtney. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class RemoteViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var setupView: UIView!

    @IBOutlet weak var sendText: UITextField!
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    // REMOTE CONTROLLER FUNCTIONS //
    
    func sendRemoteControllerCommand(command: RemoteControllerAction) {
        switch command {
        case .MoveLeft:
            sendString(str: "Left")
        case .MoveRight:
            sendString(str: "Right")
        case .Fire:
            sendString(str: "Fire")
        default:
            break
        }
    }
    
    // END REMOTE CONTROLLER FUNCTIONS //
    
    func hideSetupUI(hide: Bool) {
        // Hide or show all of the setup UI elements depending on passed in boolean
        setupView.isHidden = hide
    }
    
    func hideGameUI(hide: Bool) {
        // Hide or show all of the game UI elements depending on passed in boolean
        gameView.isHidden = hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        print(peerID)
        
        // initialize Multipeer session for use
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendString(str: String) {
        if mcSession.connectedPeers.count > 0 {
            if let stringData = str.data(using: String.Encoding.utf8) {
                do {
                    print("Sending string \(str)")
                    try mcSession.send(stringData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let str = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [unowned self] in
                print("Received string: \(str)")
            }
        }
    }
    
    func joinSession(action: UIAlertAction!) {
        print("joining")
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    // REQUIRED FUNCTIONS FOR DELEGATES //
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        if mcSession.connectedPeers.count > 0 {
            hideSetupUI(hide: true)
            hideGameUI(hide: false)
        }
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }

}

