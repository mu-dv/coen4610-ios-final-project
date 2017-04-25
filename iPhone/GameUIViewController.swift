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
    
    @IBAction func moveLeftAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.MoveLeft)
    }
    
    @IBAction func moveRightAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.MoveRight)
    }
    
    @IBAction func fireAction(_ sender: Any) {
        (parent as! RemoteViewController).sendRemoteControllerCommand(command: RemoteControllerAction.Fire)
    }
}
