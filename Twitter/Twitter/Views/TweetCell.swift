//
//  TweetCell.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/15/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking

protocol TweetCellDelegate {
    func tweetCell(replyCell:TweetCell)
    func tweetCell(replyCell:TweetCell, index:Int)
}

class TweetCell: UITableViewCell {

    var delegate: TweetCellDelegate!
    
    @IBOutlet weak var mediaContentView: UIView!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var replyConstraint: NSLayoutConstraint!
    
    var tweet: Tweet! {
        didSet {
            if let profileURL = tweet.user?.profileImage {
                 profileImageView.setImageWith(URL(string:profileURL)!)
            }
           
            screenNameLabel.text = "@" + (tweet.user?.screenName)!
            nameLabel.text = tweet.user?.name
            contentLabel.text = tweet.content
            createdAtLabel.text = tweet.createAtString
            setRetweet()
            setFavorite()
            setMedia(mediaUrls: (tweet.media?.mediaUrls)!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
    }
    
    func setMedia(mediaUrls:[String]) {
        switch mediaUrls.count {
            
        case 1:
            mediaContentView.isHidden = false
            replyConstraint.constant = 168
            //if mediaContentView.subviews.count == 0 {
                let imageView = Bundle.main.loadNibNamed("ImageView1", owner: self, options: nil)?.first as! ImageView1
                imageView.imageView.setImageWith(URL(string:mediaUrls[0])!)
                mediaContentView.addSubview(imageView)
            //}
            break
        case 2:
            mediaContentView.isHidden = false
            replyConstraint.constant = 168
            //if mediaContentView.subviews.count == 0 {
                let imageView = Bundle.main.loadNibNamed("ImageView2", owner: self, options: nil)?.first as! ImageView2
                imageView.imageView1.setImageWith(URL(string:mediaUrls[0])!)
                imageView.imageView2.setImageWith(URL(string:mediaUrls[1])!)
                mediaContentView.addSubview(imageView)
            //}
            break
        case 3:
            mediaContentView.isHidden = false
            replyConstraint.constant = 168
            //if mediaContentView.subviews.count == 0 {
                mediaContentView.isHidden = false
                let imageView = Bundle.main.loadNibNamed("ImageView3", owner: self, options: nil)?.first as! ImageView3
                imageView.imageView1.setImageWith(URL(string:mediaUrls[0])!)
                imageView.imageView2.setImageWith(URL(string:mediaUrls[1])!)
                imageView.imageView3.setImageWith(URL(string:mediaUrls[2])!)
                mediaContentView.addSubview(imageView)
            //}
            break
        default:
            mediaContentView.isHidden = true
            replyConstraint.constant = 10
            break
        }
    }
    
    func setFavorite() {
        if tweet.favorited {
            favoriteButton.setImage(UIImage(named: "ic_favorite_on"), for:.normal)
        }
        else {
            favoriteButton.setImage(UIImage(named: "ic_favorite"), for:.normal)
        }
        if tweet.favoriteCount == 0 {
            favoriteCountLabel.isHidden = true
        }
        else {
            favoriteCountLabel.isHidden = false
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
        }
    }
    
    func setRetweet() {
        if tweet.retweeted {
            retweetButton.setImage(UIImage(named: "ic_retweet_on"), for:.normal)
        }
        else {
             retweetButton.setImage(UIImage(named: "ic_retweet"), for:.normal)
        }
        if tweet.retweetCount == 0 {
            retweetCountLabel.isHidden = true
        }
        else
        {
            retweetCountLabel.isHidden = false
            retweetCountLabel.text = "\(tweet.retweetCount)"
        }
    }
    @IBAction func likeAction(_ sender: Any) {

        if tweet.favorited {
            TwitterClient.shareInstance.unlikeTweet(id: tweet.id!, success: {
                (tweet) in
                self.tweet.favoriteCount = tweet.favoriteCount
                self.tweet.favorited = tweet.favorited
                self.setFavorite()
            })
        }
        else {
            TwitterClient.shareInstance.likeTweet(id:tweet.id!, success: {
                (tweet) in
                self.tweet.favoriteCount = tweet.favoriteCount
                self.tweet.favorited = tweet.favorited
                self.setFavorite()
            })
        }
       
    }
    
    @IBAction func retweetAction(_ sender: Any) {
        if tweet.retweeted {
            TwitterClient.shareInstance.unretweet(id: tweet.id!, success: {
                (tweet) in
                self.tweet.retweeted = tweet.retweeted
                self.tweet.replyCount = tweet.replyCount
                self.setRetweet()
            })
        }
            
        else {
            TwitterClient.shareInstance.retweet(id: tweet.id!, success: {
                (tweet) in
                self.tweet.retweeted = tweet.retweeted
                self.tweet.retweetCount = tweet.retweetCount
                self.setRetweet()
            })
        }
    }
    @IBAction func replyAction(_ sender: Any) {
        delegate.tweetCell(replyCell: self)
    }
}