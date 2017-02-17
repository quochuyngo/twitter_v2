//
//  HomeViewController.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/14/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var tweets:[Tweet]!
    @IBOutlet weak var timelineTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweets = [Tweet]()
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.rowHeight = UITableViewAutomaticDimension
        timelineTableView.estimatedRowHeight = 100
        
        getTweets()
    }

    @IBAction func tweetAction(_ sender: Any) {
    }
    
    func getTweets() {
        TwitterClient.shareInstance.getTweets(success: {
            (tweets) in
            self.tweets = tweets
            self.timelineTableView.reloadData()
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        if indexPath.row == 2 {
            tweets[indexPath.row].favorited = true
        }
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}
