//
//  Tweet.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/15/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//
import UIKit

class Tweet {
    var user:User?
    var content:String = ""
    var replyCount:Int?
    var retweetCount:Int = 0
    var favoriteCount:Int = 0
    var favorited:Bool = false
    var retweeted:Bool = false
    var mediaUrls:[String] = [String]()
    init() {
        
    }
    
    init(data: NSDictionary) {
        retweetCount = (data["retweet_count"] as? Int)!
        favoriteCount = (data["favorite_count"] as? Int)!
        retweeted = data["retweeted"] as! Bool
        favorited = data["favorited"] as! Bool
        content = (data["text"] as? String)!
        user = User(data: data["user"] as! NSDictionary)
        if let entities = data["extended_entities"]{
              getMedia(entities: entities as! NSDictionary )
        }
        else {
            getMedia(entities: data["entities"] as! NSDictionary)
        }
      
    }
    
    func getMedia(entities: NSDictionary) {
        if let mediaArray = entities["media"] {
            for media in mediaArray as! [NSDictionary] {
                mediaUrls.append(media["media_url"] as! String + ":thumb")
            }
        }
        else if let media = entities["media"] {
            mediaUrls.append((media as! NSDictionary)["media_url"] as! String + ":small")
        }
    }
}
