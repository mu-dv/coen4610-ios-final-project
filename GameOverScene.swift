//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Vanderwiel, Drew on 4/24/17.
//  Copyright © 2017 Drew Vanderwiel. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene
{
    
    init(size: CGSize, won: Bool, score: Int)
    {
        
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let message = won ? "You Won!\n Score: \(score)" : "You Lose\n Score: \(score)"
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.text = message
        label.fontSize = 30
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run()
            {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
