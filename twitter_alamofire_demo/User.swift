//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    var name: String?
    var screenName: String?
    var iconURL: URL?
    
    // For user persistence
    var dictionary: [String: Any]?
    private static var _current: User?
    static var current: User? {
        get {
            if self._current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    self._current = User(dictionary: dictionary)
                }
            }
            return self._current
        }
        set (user) {
            self._current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let iconString = dictionary["profile_image_url_https"] as? String
        iconURL = URL(string: iconString!)
        
        // User persistence
        self.dictionary = dictionary
    }
}
