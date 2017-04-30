//
//  GameViewController.swift
//  SpriteKitSimpleGame
//
//  Created by user124434 on 4/23/17.
//  Copyright © 2017 Drew Vanderwiel. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    var manager: GameManagerViewController!
    var skView: SKView!
    
    var v: UIView!
    
    var t: Bool = true
    
    override func viewDidLoad() {
        if (t) {
            super.viewDidLoad()
            v = self.view
            t = false
            let scene = GameScene(size: view.bounds.size)
            skView = view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .resizeFill
            scene.manager = manager
            skView.presentScene(scene)
        }
    }
}
