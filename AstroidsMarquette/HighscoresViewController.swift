//
//  HighscoresViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/27/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit

func getHighscores(url: URL) -> String
{
    var newStr : String = "default"
    
    let task = URLSession.shared.dataTask(with: url)
    {
        (data, response, error) in
        if let d = data
        {
            if let str = String(data: d, encoding: String.Encoding.utf8)
            {
                newStr = str
            }
        }
    }
    
    task.resume()
    
    while (newStr == "default")
    {
        // wait until get something back
    }
    
    let scores = newStr.components(separatedBy: "\n")
    var index : Int = 1
    newStr = ""
    
    for scoreEntry in scores
    {
        let score = scoreEntry.components(separatedBy: ",")
        if (score.count < 2)
        {
            break
        }
        newStr = newStr + "\n\(index): \(score[0]) \(score[1])"
        index += 1
    }
    
    return newStr
}


class HighscoresViewController: UIViewController
{

    @IBOutlet weak var highScores: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let url = URL(string: "http://127.0.0.1:8081/score/shit/12145")
        {
            highScores.text = getHighscores(url: url)
        }
        else
        {
            highScores.text = "Unable to connect to server"
        }
            // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
