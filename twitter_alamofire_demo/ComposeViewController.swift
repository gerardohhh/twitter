//
//  ComposeViewController.swift
//  twitter
//
//  Created by Gerardo Parra on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate: class {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: ComposeViewControllerDelegate?

    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var textHasBeenEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        composeTextView.delegate = self
        composeTextView.text = "What's happening?"
        composeTextView.textColor = UIColor.darkGray
        composeTextView.becomeFirstResponder()
        
        tweetButton.layer.cornerRadius = 17.5
        
        let user = User.current
        iconImage.layer.cornerRadius = 15
        iconImage.af_setImage(withURL: (user?.iconURL!)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Placeholder, disabled button functionality
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = composeTextView.beginningOfDocument
        composeTextView.selectedTextRange = composeTextView.textRange(from: newPosition, to: newPosition)
        if !textHasBeenEdited {
            tweetButton.isEnabled = false
            tweetButton.alpha = 0.7
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if composeTextView.text.isEmpty {
            textHasBeenEdited = false
            composeTextView.text = "What's happening?"
            composeTextView.textColor = UIColor.darkGray
            tweetButton.isEnabled = false
            tweetButton.alpha = 0.7
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textHasBeenEdited {
            composeTextView.text = String(composeTextView.text.characters.prefix(1))
            composeTextView.textColor = UIColor.black
            textHasBeenEdited = true
        }
        characterCountLabel.text = String(140 - composeTextView.text.characters.count)
        if Int(characterCountLabel.text!)! < 0 {
            characterCountLabel.textColor = UIColor.red
            tweetButton.isEnabled = false
            tweetButton.alpha = 0.7
        } else {
            characterCountLabel.textColor = UIColor.darkGray
            tweetButton.isEnabled = true
            tweetButton.alpha = 1.0
        }
    }
    
    @IBAction func didTapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        self.view.endEditing(true)
        
        APIManager.shared.composeTweet(with: composeTextView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                self.dismiss(animated: true)
            }
        }
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
