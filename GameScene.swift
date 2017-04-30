//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by user124434 on 4/23/17.
//  Copyright © 2017 Drew Vanderwiel. All rights reserved.
//

import SpriteKit

// Global functions
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

func random() -> CGFloat
{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat
{
    return random() * (max - min) + min
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
    case NEWGAME, ACTIVEGAME, ENDGAME
}


class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Game State variables and constants
    let maxGameCount = 256;
    //let scorePerEnemy = 10000;
    var enemiesDestroyed = 0
    var score = 0
    var enemyCount = 0
    var gameState : GameState = GameState.NEWGAME
    var gameCounter : Int = 0
    
    
    // Game Objects
    var enemies = SKNode()
    let player = Player(imageNamed: "playership_1")
    let curScoreLabel = SKLabelNode(fontNamed: "Courier")
    
    // Game Level Variables
    let enemyFireFrequencyLimit : Int = 8
    let enemyMoveFrequencyLimit : Int = 32
    var enemyMoveFrequency : Int = 256
    var enemyFireFrequency : Int = 128
    //var enemyRespawnTime : Int = 0
    
    var manager: GameManagerViewController!
   
    override func didMove(to view: SKView)
    {
        self.backgroundColor = SKColor.white
        let back = SKSpriteNode(imageNamed: "background")
        
        self.addChild(back)
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.contactDelegate = self
        
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
    

    
    
    func gameUpdate()
    {
        gameCounter = (gameCounter + 1) % maxGameCount;
        
        switch(gameState)
        {
        case GameState.NEWGAME:
            // Reset score
            score = 0
            
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
            player.setScale(0.34)
            player.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)
            player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width*0.4, height: player.size.height*0.7))
            player.physicsBody?.isDynamic = true
            player.physicsBody?.categoryBitMask = PhysicsCategory.Player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyBullet
            player.physicsBody?.collisionBitMask = PhysicsCategory.None
            player.lives = 3
            player.manager = manager
            
            let playerImages = [ SKTexture(imageNamed: "playership_2"),
                        SKTexture(imageNamed: "playership_1"),
                        SKTexture(imageNamed: "playership_3"),
                        SKTexture(imageNamed: "playership_5"),
                        SKTexture(imageNamed: "playership_4") ]
            let playerIdle = SKAction.sequence([
                    SKAction.animate(with: playerImages, timePerFrame: 0.15),
                    SKAction.wait(forDuration: 0.05)
                    ])
            
            player.run(SKAction.repeatForever(playerIdle))
            
            self.addChild(player)
            
            
            let enemyImages = [ SKTexture(imageNamed: "enemyship_0"),
                                SKTexture(imageNamed: "enemyship_1"),
                                SKTexture(imageNamed: "enemyship_7"),
                                SKTexture(imageNamed: "enemyship_3"),
                                SKTexture(imageNamed: "enemyship_8"),
                                SKTexture(imageNamed: "enemyship_5"),
                                SKTexture(imageNamed: "enemyship_6"),
                                SKTexture(imageNamed: "enemyship_2"),
                                SKTexture(imageNamed: "enemyship_4")  ]
            
            
            
            
            // Create the intial number of enemies
            for y in 6..<10
            {
                for x in 4..<17
                {
                    let enemy = Alien(imageNamed: "enemyship_0")
                    enemy.setScale(0.20)
                    enemy.zRotation = CGFloat.pi;
                    
                    enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
                    enemy.physicsBody?.isDynamic = true
                    enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                    enemy.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBullet
                    enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
                    
                    let enemyIdle = SKAction.sequence([
                        SKAction.animate(with: enemyImages, timePerFrame: TimeInterval(random(min: 0.11, max: 0.2))),
                        SKAction.wait(forDuration: TimeInterval(random(min: 0.01, max: 0.05)))
                        ])
                    
                    let newX = self.size.width * CGFloat(x) * (1.0/20.0)
                    let newY = self.size.height * CGFloat(y) * (1.0/10.0)
                    
                    enemy.position = CGPoint(x: newX, y: newY)
                    
                    enemy.run(SKAction.repeatForever(enemyIdle))
                    
                    enemies.addChild(enemy)
                    
                    
                    
                    enemyCount += 1
                }
            }
            
            self.addChild(enemies)
            
            enemiesDestroyed = 0
            gameState = GameState.ACTIVEGAME
            break
        case GameState.ACTIVEGAME:
            
            curScoreLabel.text = "Lives: \(player.lives) Score: \(score)"

            
            if ((gameCounter % enemyFireFrequency) == 0)
            {
                
                let shooterIndex = Int(random(min: 0.0, max: CGFloat(enemies.children.count)))
                var index : Int = 0
                
                // iterate through the enemies and find one to shoot stuff
                for case let enemy as Alien in enemies.children
                {
                    if (index == shooterIndex)
                    {
                        // Ask the enemy to fire a bullet
                        if let bullet = enemy.shootBullet()
                        {
                            self.addChild(bullet)
                        }
                        break
                    }
                    index += 1
                }
                
                if (enemyFireFrequency > enemyFireFrequencyLimit)
                {
                    enemyFireFrequency -= 1
                }
            }
            
            // check to see if the user should fire
            if (manager.fire)
            {
                self.addChild(player.shootBullet()!)
                manager.fire = false
            }
            
            // Move the enemies down slightly every so often
            if ((gameCounter % enemyMoveFrequency) == 0)
            {
                let moveType = Int(random(min: 0.0, max: 3.0))
                var actionMove = SKAction.moveBy(x: 0.0, y: -30.0, duration: TimeInterval(1.0))
                
                switch (moveType)
                {
                case 0:
                    actionMove = SKAction.moveBy(x: -60.0, y: 0.0, duration: TimeInterval(1.0))
                    break
                case 1:
                    actionMove = SKAction.moveBy(x: 60.0, y: 0.0, duration: TimeInterval(1.0))
                    break
                case 2:
                    actionMove = SKAction.moveBy(x: 0.0, y: -30.0, duration: TimeInterval(1.0))
                    break
                default:
                    break
                }
    
                enemies.run(SKAction.sequence([actionMove]))
                
                if (enemyMoveFrequency > enemyMoveFrequencyLimit)
                {
                    enemyMoveFrequency -= 2
                }
            }
            
            // Win and lose states
            if (enemiesDestroyed >= enemyCount)
            {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true, score: score)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            else if (player.lives <= 0)
            {
                // player is dead
                //let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                //let gameOverScene = GameOverScene(size: self.size, won: false, score: score)
                //self.view?.presentScene(gameOverScene, transition: reveal)
                
                self.removeAllActions()
                self.removeAllChildren()
                manager.playerEnded(score: score)
            }
            
            player.update(size: self.size)
            
            break
        case GameState.ENDGAME:
            //do nothing
            break
        }
    }

    func bulletDidCollideWithEnemy(bullet: SKSpriteNode, enemy: SKSpriteNode)
    {
        print("Hit")
        
        bullet.removeFromParent()
        enemy.removeFromParent()
        
        enemiesDestroyed += 1
        score += 100
    }
    
    func bulletDidCollideWithPlayer(bullet: SKSpriteNode)
    {
        print("Hit player")
        
        bullet.removeFromParent()
        
        player.lives -= 1
        
        // Play hit sound
        let num = Int(random(min: 1.0, max: 4.0))
            
        run(SKAction.playSoundFileNamed("playerhit_0\(num).wav", waitForCompletion: false))
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

