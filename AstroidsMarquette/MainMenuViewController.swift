//
//  MainMenuViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/25/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MainMenuViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate
{
    
    var peerID               : MCPeerID!
    var mcSession            : MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var debugText    : UILabel!
    
    var manager: GameManagerViewController!
    
    func startHosting(action: UIAlertAction!)
    {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "astroids-m", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        // Receive strings from iPhone controller
        if let inputString = String(data: data, encoding: .utf8)
        {
            DispatchQueue.main.async {
                [unowned self] in
                // MAGIC HAPPENS HERE //
                print("Received string: \(inputString)")
                self.receiveNetworkEvent(input: inputString)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "LaunchGameSegue")
        {
            manager = (segue.destination as! GameManagerViewController)
        }
    }
    
    func receiveNetworkEvent(input: String)
    {
        if (input == "LeftDown")
        {
            manager.direction = Direction.LEFT
        }
        if (input == "LeftUp")
        {
            manager.direction = Direction.NONE
        }
        if (input == "RightDown")
        {
            manager.direction = Direction.RIGHT
        }
        if (input == "RightUp")
        {
            manager.direction = Direction.NONE
        }
        if (input == "FireDown")
        {
            manager.fire = true
        }
        if (input == "FireUp")
        {
            manager.fire = false
        }
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()

        peerID = MCPeerID(displayName: UIDevice.current.name)
        print(peerID)
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession.delegate = self
        
        startHosting(action: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue)
    {
    }
    
    // REQUIRED FUNCTIONS FOR DELEGATES //
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        // Empty
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
        // Empty
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?)
    {
        // Empty
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController)
    {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController)
    {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        switch state
        {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            debugText.text = "\(peerID.displayName) has connected."
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            debugText.text = "\(peerID.displayName) is connecting..."
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            debugText.text = "Waiting for controller to connect..."
        }
    }
}
