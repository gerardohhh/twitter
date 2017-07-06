//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    
    var favoriteCount = 0
    var retweetCount = 0
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            let poster = tweet.user
            nameLabel.text = poster.name
            screenNameLabel.text = "@\(poster.screenName!)"
            retweetsLabel.text = String(tweet.retweetCount)
            favoritesLabel.text = String(tweet.favoriteCount ?? 0)
            timestampLabel.text = " · \(tweet.createdAtString)"
            iconImageView.af_setImage(withURL: poster.iconURL!)
            
            favoriteButton.isSelected = tweet.favorited!
            retweetButton.isSelected = tweet.retweeted
            
            favoriteCount = tweet.favoriteCount ?? 0
            retweetCount = tweet.retweetCount
            if poster.verified! == false {
                verifiedImage.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = 22.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshData() {
        retweetsLabel.text = String(retweetCount)
        favoritesLabel.text = String(favoriteCount)
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        retweetButton.isSelected = !retweetButton.isSelected
        
        if retweetButton.isSelected {
            retweetCount += 1
            refreshData()
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            retweetCount -= 1
            refreshData()
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            }
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        
        if favoriteButton.isSelected {
            favoriteCount += 1
            refreshData()
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                }
            }
        } else {
            favoriteCount -= 1
            refreshData()
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                }
            }
        }
    }
}
