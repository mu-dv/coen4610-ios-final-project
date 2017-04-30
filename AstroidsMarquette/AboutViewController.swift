//
//  AboutViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/4/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callButtonAction(_ sender: Any) {
        let highscoreController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Highscore Name")
        (highscoreController as! HighscoreNameViewController).highscore = 10
        self.present(highscoreController, animated: true, completion: nil)
    }
}
