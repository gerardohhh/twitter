//
//  ProfileViewController.swift
//  twitter
//
//  Created by Gerardo Parra on 7/3/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var tweets: [Tweet] = []
    var user: User? = nil
    var fromTimeline: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = logOutButton.currentTitleColor.cgColor
        logOutButton.layer.cornerRadius = logOutButton.frame.height / 2

        if !fromTimeline {
            user = User.current
        }
        
        iconBorder.layer.cornerRadius = iconBorder.frame.width / 2
        iconImage.layer.cornerRadius = iconImage.frame.width / 2
        
        iconImage.af_setImage(withURL: (user?.iconURL)!)
        coverImage.af_setImage(withURL: (user?.coverURL)!)
        nameLabel.text = user?.name
        let username = user?.screenName!
        screenNameLabel.text = "@\(username!)"
        locationLabel.text = user?.location
        followingCount.text = String((user?.following!)!)
        followerCount.text = String((user?.followers!)!)
        if user?.followers! == 1 {
            followersLabel.text = "Follower"
        }
        if (user?.verified)! {
            verifiedImage.isHidden = false
        }
        
        if fromTimeline {
            logOutButton.isHidden = true
        } else {
            logOutButton.isHidden = false
        }
        closeButton.isHidden = !logOutButton.isHidden
        
        APIManager.shared.getUserTimeLine(with: (user?.screenName)!) { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
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
