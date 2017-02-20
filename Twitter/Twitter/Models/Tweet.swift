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
    var id:Int?
    var replyCount:Int?
    var retweetCount:Int = 0
    var favoriteCount:Int = 0
    var favorited:Bool = false
    var retweeted:Bool = false
    var createdAt:Date?
    var createAtString:String?
    var media:Media?
    init() {
        
    }
    
    init(data: NSDictionary) {
        id = data["id"] as? Int
        retweetCount = (data["retweet_count"] as? Int)!
        favoriteCount = (data["favorite_count"] as? Int)!
        retweeted = data["retweeted"] as! Bool
        favorited = data["favorited"] as! Bool
        content = (data["text"] as? String)!
        user = User(data: data["user"] as! NSDictionary)
        
        if let timestampString = data["created_at"] as? String {
            let timeFormater = DateFormatter()
            timeFormater.dateFormat = "EEE MMM d HH:mm:ss Z y" // Tue Aug 28 21:16:23 +0000 2012
            createdAt = timeFormater.date(from: timestampString)
            createAtString = convertDateToString()
        }
        
        if let entities = data["extended_entities"]{
             media = Media(data: entities as! NSDictionary)
        }
        else {
            media = Media(data: data["entities"] as! NSDictionary)
        }
        if content.contains((media?.url)!) {
            content = content.replacingOccurrences(of: (media?.url)!, with: "")
        }
    }
    
    func convertDateToString(short: Bool = true) -> String {
        var secondLabel: String
        var minuteLabel: String
        var hourLabel: String
        var dayLabel: String
        
        if short {
            secondLabel = "s"
            minuteLabel = "m"
            hourLabel = "h"
            dayLabel = "d"
        } else {
            secondLabel = " seconds ago"
            minuteLabel = " mimutes ago"
            hourLabel = " hours ago"
            dayLabel = " days ago"
        }
        
        let min = 60
        let hour = min * 60
        let day = hour * 24
        let week = day * 7
        let year = day * 365
        let elapsedTime = Date().timeIntervalSince(createdAt!)
        let duration = Int(elapsedTime)
        
        if duration < min {
            return "\(duration)\(secondLabel)"
        } else if duration < hour {
            let minDur = duration / min
            return "\(minDur)\(minuteLabel)"
        } else if duration < day {
            let hourDur = duration / hour
            return "\(hourDur)\(hourLabel)"
        } else if duration < week {
            let dayDur = duration / day
            return "\(dayDur)\(dayLabel)"
        } else if duration < year {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dMMM"
            let dateString = dateFormatter.string(from: createdAt!)
            return dateString
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dMMM y"
            let dateString = dateFormatter.string(from: createdAt!)
            return dateString
        }
    }
}
