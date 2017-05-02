//
//  HighscoreNameViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/30/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit

class HighscoreNameViewController: UIViewController
{
    
    var highscore: Int = 0
    var manager: GameManagerViewController!
    
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func submitButtonAction(_ sender: Any)
    {
        if let url = URL(string: "http://127.0.0.1:8081/score/\(nameField.text!)/\(highscore)")
        {
            _ = getHighscores(url: url)
        }
        
        let alert = UIAlertController( title: "Submit Score", message: "Score Saved!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction( title: "Exit", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func playAgain(_ sender: Any) {
        manager.startGame()
        
        // dismiss viewcontroller
        dismiss(animated: true, completion: nil)
    }

    @IBAction func exitApp(_ sender: Any) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
