//
//  ProfileScrollableViewController.swift
//  twitter
//
//  Created by Gerardo Parra on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileScrollableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconBorder: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    var tweets: [Tweet] = []
    var user: User? = nil
    var fromTimeline: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
        // Toggle views based on user
        if !fromTimeline {
            user = User.current
        }
        logOutButton.isHidden = fromTimeline
        followingButton.isHidden = !fromTimeline
        
        // Format log out, following buttons
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = logOutButton.currentTitleColor.cgColor
        logOutButton.layer.cornerRadius = logOutButton.frame.height / 2
        
        if (user?.isFollowing)! {
            followingButton.backgroundColor = logOutButton.currentTitleColor
            followingButton.setTitleColor(UIColor.white, for: .normal)
        } else if user?.screenName == User.current?.screenName {
            followingButton.isHidden = true
        } else {
            followingButton.layer.borderWidth = 1
            followingButton.layer.borderColor = logOutButton.currentTitleColor.cgColor
            followingButton.setTitle("Follow", for: .normal)
        }
        followingButton.layer.cornerRadius = followingButton.frame.height / 2
        // Format images
        iconBorder.layer.cornerRadius = iconBorder.frame.width / 2
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        // Change close button tint
        let origImage = UIImage(named: "close-icon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(tintedImage, for: .normal)
        closeButton.tintColor = UIColor.white
        closeButton.isHidden = !logOutButton.isHidden
        
        
        // Set profile data
        iconImage.af_setImage(withURL: (user?.iconURL)!)
        coverImage.af_setImage(withURL: (user?.coverURL)!)
        nameLabel.text = user?.name
        let username = user?.screenName!
        screenNameLabel.text = "@\(username!)"
        locationLabel.text = user?.location
        
        // Add commas to large follower numbers
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedFollowers = numberFormatter.string(from: NSNumber(value: (user?.followers)!))!
        let formattedFollowing = numberFormatter.string(from: NSNumber(value: (user?.following)!))!
        followingCount.text = String(formattedFollowing)
        followerCount.text = String(formattedFollowers)
        // Proper number grammar
        if user?.followers! == 1 {
            followersLabel.text = "Follower"
        }
        
        // Verified icon
        if (user?.verified)! {
            verifiedImage.isHidden = false
        }
        
        // Fetch tweets
        APIManager.shared.getUserTimeLine(with: (user?.screenName)!) { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    @IBAction func didTapFollowing(_ sender: Any) {
        if followingButton.currentTitle == "Follow" {
            followingButton.backgroundColor = logOutButton.currentTitleColor
            followingButton.setTitleColor(UIColor.white, for: .normal)
            followingButton.setTitle("Following", for: .normal)
        } else {
            followingButton.layer.borderWidth = 1
            followingButton.layer.borderColor = logOutButton.currentTitleColor.cgColor
            let titleColor = followingButton.layer.borderColor
            followingButton.setTitleColor(UIColor(cgColor: titleColor!), for: .normal)
            followingButton.layer.backgroundColor = UIColor.clear.cgColor
            followingButton.setTitle("Follow", for: .normal)
        }
    }

    @IBAction func didTapLogOut(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true)
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
