//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import ActiveLabel

protocol TweetCellDelegate: class {
    func tweetCell(_ tweetCell: TweetCell, didTap user: User)
}

class TweetCell: UITableViewCell {
    
    weak var delegate: TweetCellDelegate?
    
    @IBOutlet weak var tweetTextLabel: ActiveLabel!
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
    @IBOutlet weak var verifiedLeading: NSLayoutConstraint!
    @IBOutlet weak var verifiedWidth: NSLayoutConstraint!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var favoriteCount = 0
    var retweetCount = 0
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            tweetTextLabel.handleURLTap { url in UIApplication.shared.open(url) }
            
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
            
            if tweet.mediaUrl != nil {
                mediaImage.af_setImage(withURL: tweet.mediaUrl!)
                imageHeight.constant = 200
            } else {
                imageHeight.constant = 0
            }
            
            if !(poster.verified!) {
                verifiedLeading.constant = 0
                verifiedWidth.constant = 0
            } else {
                verifiedLeading.constant = 3
                verifiedWidth.constant = 14
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = 22.5
        mediaImage.layer.cornerRadius = 10
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
                }
            }
        } else {
            retweetCount -= 1
            refreshData()
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
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
    
    @IBAction func didTapUser(_ sender: Any) {
        delegate?.tweetCell(self, didTap: tweet.user)
    }
}
