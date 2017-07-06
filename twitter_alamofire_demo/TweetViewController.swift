//
//  TweetViewController.swift
//  twitter
//
//  Created by Gerardo Parra on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tweet"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        ]

        iconImage.layer.cornerRadius = iconImage.frame.height / 2
        
        let poster: User = (tweet?.user)!
        
        iconImage.af_setImage(withURL: (poster.iconURL)!)
        nameLabel.text = poster.name
        screenNameLabel.text = "@\(poster.screenName!)"
        if !(poster.verified!) {
            verifiedIcon.isHidden = true
        } else {
            verifiedIcon.isHidden = false
        }
        
        tweetLabel.text = tweet?.text
        timestampLabel.text = tweet?.createdAtString
        
        retweetCount.text = String((tweet?.retweetCount)!)
        favoriteCount.text = String((tweet?.favoriteCount)!)
        
        if (tweet?.retweeted)! {
            retweetButton.isSelected = true
        }
        if (tweet?.favorited)! {
            favoriteButton.isSelected = true
        }
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
