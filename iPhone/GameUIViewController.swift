//
//  GameUIViewController.swift
//  InvadersController
//
//  Created by Austin Anderson on 4/25/17.
//  Copyright © 2017 Connery, Courtney. All rights reserved.
//

import UIKit

class GameUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moveLeftDownAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.MoveLeftDown)
    }
    
    @IBAction func moveLeftUpAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.MoveLeftUp)
    }
    
    @IBAction func moveRightDownAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.MoveRightDown)
    }
    
    @IBAction func moveRightUpAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.MoveRightUp)
    }
    
    @IBAction func fireDownAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.FireDown)
    }
    
    @IBAction func fireUpAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.FireUp)
    }
}
