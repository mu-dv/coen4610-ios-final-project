//
//  HighscoreNameViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/30/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit

class HighscoreNameViewController: UIViewController {
    
    var highscore: Int = 0
    
    @IBOutlet weak var highscoreLabel: UILabel!

    @IBAction func submitButtonAction(_ sender: Any) {
        // TODO: do network things here
        
        // dismiss viewcontroller
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // assuming highscore was set before the view loaded
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
