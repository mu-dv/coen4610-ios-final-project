//
//  GameManagerViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/30/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit

class GameManagerViewController: UIViewController
{
    
    var direction: Direction = Direction.NONE
    var fire     : Bool = false
    
    var gameViewController: GameViewController!
    
    func playerEnded(score: Int)
    {
        print("Score: \(score)")
        
        let highscoreController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Highscore Name")
        (highscoreController as! HighscoreNameViewController).highscore = score
        (highscoreController as! HighscoreNameViewController).manager = self
        self.present(highscoreController, animated: true, completion: nil)
    }
    
    func startGame()
    {
        gameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameViewController.manager = self
        //self.present(gameViewController, animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = gameViewController
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        startGame()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
