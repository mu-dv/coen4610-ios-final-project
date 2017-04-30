	//
//  Player.swift
//  SpriteKitSimpleGame
//
//  Created by user124434 on 4/25/17.
//  Copyright © 2017 Drew Vanderwiel. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction
{
    case LEFT, RIGHT, NONE
}
    
class Player : SKSpriteNode
{
    let moveAmt : CGFloat = 30.0
    var lives : Int = 0
    
    var manager: GameManagerViewController!
    
    func shootBullet() -> SKSpriteNode?
    {
        // for network usage
        let bullet = SKSpriteNode(imageNamed: "player_bullet")
        bullet.setScale(0.5)
        bullet.position = self.position + CGPoint (x: 0.0, y: self.size.height/2)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        let newPos = self.position + CGPoint (x: 0.0, y: 1000)
        
        // Create the actions
        let actionMove = SKAction.move(to: newPos, duration: 4.0)
        let actionMoveDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        // Play shooting sound
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        return bullet
    }
    
    func shootBullet(touchLocation : CGPoint) -> SKSpriteNode?
    {
        // Set up initial location of projectile
        let bullet = SKSpriteNode(imageNamed: "player_bullet")
        bullet.setScale(0.5)
        bullet.position = self.position + CGPoint (x: 0.0, y: self.size.height/2)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        // Determine offset of location to projectile
        let offset = touchLocation - bullet.position
        
        // Bail out if you are shooting down
        if (offset.y < 0)
        {
            return nil
        }
        
        // Get the direction of where to shoot
        let direction = offset.normalized()
        
        // Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // Add the shoot amount to the current position
        let realDest = shootAmount + bullet.position
        
        // Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        // Play shooting sound
        run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        return bullet
    }
    
    
    func update(size: CGSize)
    {
        if (manager.direction == Direction.LEFT)
        {
            position.x -= moveAmt
        }
        else if (manager.direction == Direction.RIGHT)
        {
            position.x += moveAmt
        }

        // Fix x
        if (position.x - self.size.width/2 < 0)
        {
            position.x = self.size.width/2
        }
        else if (position.x + self.size.width/2 > size.width)
        {
            position.x = size.width - self.size.width/2
        }

    }
    
    
    
}
