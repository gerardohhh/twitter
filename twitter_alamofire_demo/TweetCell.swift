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
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            let poster = tweet.user
            nameLabel.text = poster.name
            screenNameLabel.text = "@\(poster.screenName!)"
            retweetsLabel.text = String(tweet.retweetCount)
            favoritesLabel.text = String(tweet.favoriteCount!)
            timestampLabel.text = "· \(tweet.createdAtString)"
            iconImageView.af_setImage(withURL: poster.iconURL!)
            
            favoriteButton.isSelected = tweet.favorited!
            retweetButton.isSelected = tweet.retweeted
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
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if retweetButton.isSelected {
            retweetButton.isSelected = false
            retweetsLabel.text = String(Int(retweetsLabel.text!)! - 1)
        } else {
            retweetButton.isSelected = true
            retweetsLabel.text = String(Int(retweetsLabel.text!)! + 1)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        if favoriteButton.isSelected {
            favoriteButton.isSelected = false
            favoritesLabel.text = String(Int(favoritesLabel.text!)! - 1)
        } else {
            favoriteButton.isSelected = true
            favoritesLabel.text = String(Int(favoritesLabel.text!)! + 1)
        }
    }
}
