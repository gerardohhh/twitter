//
//  ProfileViewController.swift
//  twitter
//
//  Created by Gerardo Parra on 7/3/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconBorder: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.current
        
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
        if (user?.verified)! {
            verifiedImage.isHidden = false
        }
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
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
