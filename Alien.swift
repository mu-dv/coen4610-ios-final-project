//
//  Alien.swift
//  SpriteKitSimpleGame
//
//  Created by user124434 on 4/25/17.
//  Copyright © 2017 Drew Vanderwiel. All rights reserved.
//

import Foundation
import SpriteKit

class Alien : SKSpriteNode
{
    
    func shootBullet() -> SKSpriteNode?
    {
        // 2 - Set up initial location of projectile
        let bullet = SKSpriteNode(imageNamed: "projectile")
        bullet.position = self.position
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.EnemyBullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        let newPos = self.position + CGPoint(x: 0.0, y: -1000)
        
        // Create the actions
        let actionMove = SKAction.move(to: newPos, duration: 4.0)
        let actionMoveDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        // Play shooting sound
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        return bullet
    }
}
