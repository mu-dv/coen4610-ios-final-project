//
//  MainMenuViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/25/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MainMenuViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID               : MCPeerID!
    var mcSession            : MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var debugText    : UILabel!
    
    // CURRECT DIRECTION AND FIRE STATUS //
    var direction: Direction = Direction.NONE
    var fire     : Bool = false
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "astroids-m", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Receive strings from iPhone controller
        if let inputString = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { [unowned self] in
                // MAGIC HAPPENS HERE //
                print("Received string: \(inputString)")
                self.receiveNetworkEvent(input: inputString)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LaunchGameSegue") {
            (segue.destination as! GameViewController).mainMenu = self
        }
    }
    
    func receiveNetworkEvent(input: String)
    {
        if (input == "LeftDown")
        {
            direction = Direction.LEFT
        }
        if (input == "LeftUp")
        {
            direction = Direction.NONE
        }
        if (input == "RightDown")
        {
            direction = Direction.RIGHT
        }
        if (input == "RightUp")
        {
            direction = Direction.NONE
        }
        if (input == "FireDown")
        {
            fire = true
        }
        if (input == "FireUp")
        {
            fire = false
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        peerID = MCPeerID(displayName: UIDevice.current.name)
        print(peerID)
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
        
        startHosting(action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
    // REQUIRED FUNCTIONS FOR DELEGATES //
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
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
