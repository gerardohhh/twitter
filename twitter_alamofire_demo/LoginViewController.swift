//
//  LoginViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 4/4/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import Prephirences

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 22.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        APIManager.shared.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
