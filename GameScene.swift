//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by user124434 on 4/23/17.
//  Copyright © 2017 Drew Vanderwiel. All rights reserved.
//

import SpriteKit


func + (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint
{
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint
{
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint
{
    func length() -> CGFloat
    {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint
    {
        return self / length()
    }
    
    func dist(pt: CGPoint) -> CGFloat
    {
        let xx = (self.x - pt.x)*(self.x - pt.x)
        let yy = (self.y - pt.y)*(self.y - pt.y)
        return sqrt(xx + yy)
    }
    
}

struct PhysicsCategory
{
    static let None             : UInt32 = 0
    static let All              : UInt32 = UInt32.max
    static let Enemy            : UInt32 = 0b1       // 1
    static let Player           : UInt32 = 0b10      // 2
    static let PlayerBullet     : UInt32 = 0b100     // 4
    static let EnemyBullet      : UInt32 = 0b1000     // 8
}

enum GameState
{
    case NEWGAME, ACTIVEGAME
}


class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Game State variables and constants
    let maxGameCount = 256;
    var enemiesDestroyed = 0
    var enemyCount = 0
    var gameState : GameState = GameState.NEWGAME
    var gameCounter : Int = 0
    
    // Game Objects
    var enemies = SKNode()
    let player = Player(imageNamed: "player")
    let curScoreLabel = SKLabelNode(fontNamed: "Courier")
    
    var mainMenu: MainMenuViewController!
   
    override func didMove(to view: SKView)
    {
        
        backgroundColor = SKColor.white
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        gameState = GameState.NEWGAME;
        gameCounter = 0
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(gameUpdate), // update the game
                SKAction.wait(forDuration: 0.04) // every 1/25 of a second
                ])
        ))
        

        //let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        //backgroundMusic.autoplayLooped = true
        //addChild(backgroundMusic)
    }
    
    func random() -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat
    {
        return random() * (max - min) + min
    }
    
    
    func gameUpdate()
    {
        gameCounter = (gameCounter + 1) % maxGameCount;
        
        switch(gameState)
        {
        case GameState.NEWGAME:
            
            enemyCount = 0
            // Clear out all children
            enemies.removeAllChildren()
            self.removeAllChildren()
            
            
            // Initialize Score label
            curScoreLabel.text = "Lives: 0 Score: 0"
            curScoreLabel.fontSize = 20
            curScoreLabel.fontColor = SKColor.black
            curScoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.96)
            self.addChild(curScoreLabel)
            
            // Initialize player
            player.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)
            player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
            player.physicsBody?.isDynamic = true
            player.physicsBody?.categoryBitMask = PhysicsCategory.Player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyBullet
            player.physicsBody?.collisionBitMask = PhysicsCategory.None
            player.lives = 3
            player.mainMenu = mainMenu
            self.addChild(player)
            
            // Create the intial number of enemies
            for y in 6..<10
            {
                for x in 1..<10
                {
                    let enemy = Alien(imageNamed: "monster")
                    
                    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                    enemy.physicsBody?.isDynamic = true
                    enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBullet
                    enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
                    
                    let newX = self.size.width * CGFloat(x) * (1.0/10.0)
                    let newY = self.size.height * CGFloat(y) * (1.0/10.0)
                    
                    enemy.position = CGPoint(x: newX, y: newY)
                    
                    //self.addChild(enemy)
                    enemies.addChild(enemy)
                    
                    enemyCount += 1
                }
            }
            
            self.addChild(enemies)
            
            enemiesDestroyed = 0
            gameState = GameState.ACTIVEGAME
            break
        case GameState.ACTIVEGAME:
            
            curScoreLabel.text = "Lives: \(player.lives) Score: \(enemiesDestroyed)"

            
            if ((gameCounter % 16) == 0)
            {
                
                let shooterIndex = Int(random(min: 0.0, max: CGFloat(enemies.children.count)))
                var index : Int = 0
                
                for case let enemy as Alien in enemies.children
                {
                    if (index == shooterIndex)
                    {
                        // Ask the player to fire a bullet
                        if let bullet = enemy.shootBullet()
                        {
                            self.addChild(bullet)
                        }
                        break
                    }
                    index += 1
                }
                
                // check to see if the user should fire
                if (mainMenu.fire)
                {
                    self.addChild(player.shootBullet()!)
                }
            }
            
            // Move the enemies down slightly every so often
            if ((gameCounter % 128) == 0)
            {
                let actionMove = SKAction.moveBy(x: 0.0, y: -15.0, duration: TimeInterval(1.0))
                enemies.run(SKAction.sequence([actionMove]))
            }
            
            if (enemiesDestroyed >= enemyCount)
            {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true, score: enemiesDestroyed)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            else if (player.lives <= 0)
            {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: false, score: enemiesDestroyed)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            
            player.update(size: self.size)
            
            break
        }
    }

    func bulletDidCollideWithEnemy(bullet: SKSpriteNode, enemy: SKSpriteNode)
    {
        print("Hit")
        
        bullet.removeFromParent()
        enemy.removeFromParent()
        
        enemiesDestroyed += 1
    }
    
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode)
    {
        print("Hit player")
        
        bullet.removeFromParent()
        
        player.lives -= 1
    }
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if (firstBody.categoryBitMask & PhysicsCategory.Enemy != 0)
        {
            if ( (secondBody.categoryBitMask & PhysicsCategory.PlayerBullet != 0) &&
                (secondBody.contactTestBitMask & PhysicsCategory.Enemy != 0) )
            {
                if let enemy = firstBody.node as? SKSpriteNode, let
                    bullet = secondBody.node as? SKSpriteNode
                {
                    bulletDidCollideWithEnemy(bullet: bullet, enemy: enemy)
                }
            }
        }
        else if (firstBody.categoryBitMask & PhysicsCategory.Player != 0)
        {
            if ((secondBody.categoryBitMask & PhysicsCategory.EnemyBullet != 0) &&
                (secondBody.contactTestBitMask & PhysicsCategory.Player != 0))
            {
                if let bullet = secondBody.node as? SKSpriteNode
                {
                    bulletDidCollideWithPlayer(bullet: bullet)
                }
            }
        }
        
    }
}





/*
 
 func addMonster()
 {
 
 // Create sprite
 let monster = SKSpriteNode(imageNamed: "monster")
 
 monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
 monster.physicsBody?.isDynamic = true // 2
 monster.physicsBody?.categoryBitMask = PhysicsCategory.Enemy // 3
 monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
 monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
 
 // Determine where to spawn the monster along the Y axis
 let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
 
 // Position the monster slightly off-screen along the right edge,
 // and along a random position along the Y axis as calculated above
 monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
 
 // Add the monster to the scene
 addChild(monster)
 
 // Determine speed of the monster
 let actualDuration = random(min: CGFloat(10.0), max: CGFloat(15.0))
 
 // Create the actions
 let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
 let actionMoveDone = SKAction.removeFromParent()
 
 let loseAction = SKAction.run()
 {
 
 let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
 let gameOverScene = GameOverScene(size: self.size, won: false)
 self.view?.presentScene(gameOverScene, transition: reveal)
 }
 monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
 
 }
 */
