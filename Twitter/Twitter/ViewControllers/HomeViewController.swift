//
//  HomeViewController.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/14/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeViewController: UIViewController {

    var tweets:[Tweet]!
    var isMoreLoadingData:Bool = false
    var refreshControl:UIRefreshControl!
    var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var timelineTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweets = [Tweet]()
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.rowHeight = UITableViewAutomaticDimension
        timelineTableView.estimatedRowHeight = 100
        
        getTweets(id: nil)
        refreshControl = UIRefreshControl()
        indicatorView = UIActivityIndicatorView()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        timelineTableView.insertSubview(refreshControl, at: 0)
        indicatorLoading()
    }

    @IBAction func tweetAction(_ sender: Any) {
    }
    
    func getTweets(id:Int?) {
        TwitterClient.shareInstance.getTweets(max_id: id, success: {
            (tweets) in
            if id == nil {
                 self.tweets = tweets
            }
            else {
                self.tweets.append(contentsOf: tweets)
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
            }
            self.isMoreLoadingData = false
            self.refreshControl.endRefreshing()
            self.timelineTableView.reloadData()
           
        })
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getTweets(id: nil)
    }
    
    func indicatorLoading() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: timelineTableView.superview!.frame.width, height: 50))
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicatorView .center = footerView.center
        indicatorView .isHidden = true
        footerView.addSubview(indicatorView )
        timelineTableView.tableFooterView = footerView
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewTweetSegue" {
            let vc = segue.destination as! NewTweetViewController
            vc.delegate = self
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreLoadingData{
            //calculate
            let scrollViewContentHeight = timelineTableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - timelineTableView.bounds.size.height
            if scrollView.contentOffset.y > scrollViewOffsetThreshold && timelineTableView.isDragging{
                isMoreLoadingData = true
                if tweets.count > 0 {
                        getTweets(id: (tweets.last?.id))
                }
            }
        }
    }

}

extension HomeViewController: NewTweetViewControllerDelegate {
    func newTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        timelineTableView.reloadData()
    }
}
