//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/21/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tweetTableView: UITableView!
    var tweets:[Tweet] = [Tweet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 100
    }
    
}

extension TweetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
}
