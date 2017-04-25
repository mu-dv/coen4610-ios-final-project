//
//  GameViewController.swift
//  AstroidsMarquette
//
//  Created by Austin Anderson on 4/6/17.
//  Copyright © 2017 austinandersonphoto. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var backgroundOriginalFrame: CGRect!
    
    func addNewBackgroundImage() {
        print("adding new image to scroll")
        // create new image
        let imageName = #imageLiteral(resourceName: "star-background")
        let imageFrame = backgroundOriginalFrame
        let imageView = UIImageView(frame: imageFrame!)
        imageView.image = imageName
        
        UIView.animate(withDuration: 15.0, animations: {
            print(imageView.frame)
            var frame = imageView.frame
            frame.origin.y -= frame.size.height
            
            imageView.frame = frame
        }, completion: {finished in
            print("done scrolling new")
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // save original background location from frame
        let org = backgroundImage.frame
        backgroundOriginalFrame = org
        
        UIView.animate(withDuration: 15.0, animations: {
            print(self.backgroundImage.frame)
            var frame = self.backgroundImage.frame
            frame.origin.y -= frame.size.height
            
            self.backgroundImage.frame = frame
        }, completion: { finished in
            print("done scrolling")
            print(self.backgroundImage.frame)
            self.addNewBackgroundImage()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
