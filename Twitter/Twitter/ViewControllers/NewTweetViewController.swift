//
//  TweetViewController.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/15/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol NewTweetViewControllerDelegate {
     func newTweet(tweet:Tweet)
    func newTweet(replyTweet:Tweet, index:Int)
}

class NewTweetViewController: UIViewController {

    var delegate: NewTweetViewControllerDelegate!
    var content = "What 's happening?"
    var characterCount = 140 {
        didSet{
            characterCountLabel.text = "\(characterCount)"
        }
    }
    var isTweeted = false
    let limitCharacters = 140
    var tweet:Tweet?
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var replyToLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        NotificationCenter.default.addObserver(self, selector: #selector(NewTweetViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTweetViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if tweet != nil {
            replyView.isHidden = false
            let name = tweet?.user?.name!
            replyToLabel.text = "Reply \(name!)"
            let screenName = tweet?.user!.screenName!
            contentTextView.text = "@ " + screenName!
            tweetButton.setTitle("Reply", for: .normal)
        }
        else {
            replyView.isHidden = true
        }
    }
    
    func initView() {
        profileImage.setImageWith(URL(string:(User.currentUser?.profileImage)!)!)
        contentTextView.text = content
        contentTextView.becomeFirstResponder()
        contentTextView.delegate = self
        
        setTweetutton(isTweetOn: false)
        tweetButton.layer.cornerRadius = 4
    }
    
    func setTweetutton(isTweetOn: Bool) {
        if isTweetOn {
            tweetButton.isEnabled = true
            tweetButton.backgroundColor = UIColor(colorLiteralRed: 85/255, green: 174/255, blue: 237/255, alpha: 1)

            tweetButton.titleLabel?.textColor = UIColor.white
        }
        else {
            tweetButton.isEnabled = false
            tweetButton.backgroundColor = UIColor(colorLiteralRed: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            tweetButton.layer.borderColor = UIColor(colorLiteralRed: 128/255, green: 128/255, blue: 128/255, alpha: 1).cgColor
            tweetButton.titleLabel?.textColor = UIColor(colorLiteralRed: 128/255, green: 128/255, blue: 128/255, alpha: 1)
            tweetButton.layer.borderWidth = 0.5
        }
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
        if !isTweeted {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            isTweeted = true
            if tweet != nil {
                TwitterClient.shareInstance.tweet(status: contentTextView.text, replyId: tweet?.replyId, success: {
                    (tweet) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.navigationController?.popViewController(animated: true)
                    
                })
            }
            else {
                TwitterClient.shareInstance.tweet(status: contentTextView.text, replyId: nil, success: {
                    (tweet) in
                    self.delegate.newTweet(tweet: tweet)
                    self.isTweeted = false
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.navigationController?.popViewController(animated: true)
                })
            }

        }
    }
}

extension NewTweetViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.contains("'s happening?"){
            contentTextView.text = ""
        }
        //contentTextView.text.replacingOccurrences(of: content, with: "")
        characterCount = limitCharacters - textView.text.characters.count
        if characterCount == limitCharacters || characterCount < 0 {
            setTweetutton(isTweetOn: false)
        }
        else {
            setTweetutton(isTweetOn: true)
            characterCountLabel.text = "\(characterCount)"
        }
    }
    
//    public func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text.contains("'s happening?"){
//            contentTextView.text = ""
//        }
//    }
//    public func textViewDidEndEditing(_ textView: UITextView){
//        if textView.text == ""{
//           
//            contentTextView.textColor = UIColor.gray
//
//        }
//    }

}
