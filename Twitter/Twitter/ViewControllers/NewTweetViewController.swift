//
//  TweetViewController.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/15/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        NotificationCenter.default.addObserver(self, selector: #selector(NewTweetViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTweetViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func initView() {
        toolsView.layer.borderColor = UIColor.darkGray.cgColor
        toolsView.layer.borderWidth = 1
        
        tweetButton.layer.cornerRadius = 4
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
        }

    }
    
    func keyboardWillHide(notification: Notification) {
        bottomConstraint.constant = 0
    }
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func tweetAction(_ sender: Any) {
    }
    
}
