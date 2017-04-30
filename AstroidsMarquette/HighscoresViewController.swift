//
//  HighscoresViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/27/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit

class HighscoresViewController: UIViewController
{

    @IBOutlet weak var highScores: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let url = URL(string: "http://192.168.1.2:8081/score/name/1234")
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
        return newStr
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
