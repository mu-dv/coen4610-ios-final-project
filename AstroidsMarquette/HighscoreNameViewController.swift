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
        
        manager.startGame()
        
        // dismiss viewcontroller
        dismiss(animated: true, completion: nil)
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
