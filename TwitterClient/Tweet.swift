//
//  Tweet.swift
//  TwitterClient
//
//  Created by Julian Test on 2/6/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestampDate: String?
    var timestampTime: String?
    var retweetCount: Int = 0
    var favoritesCount: Int  = 0
    var retweeted: Bool?
    var retweeted_status: Tweet?
    var favorited: Bool?
    var tweetId: Int?
    var tweetId_str: String?
    var tweetUser: User?
    
    var year: Int?
    var month: Int?
    var day: Int?
    var hour: Int?
    var minute: Int?
    
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let timestamp = formatter.date(from: timestampString)
            let calendar = Calendar.current
            year = calendar.component(.year, from: timestamp!)
            month = calendar.component(.month, from: timestamp!)
            day = calendar.component(.day, from: timestamp!)
            hour = calendar.component(.hour, from: timestamp!)
            minute = calendar.component(.minute, from: timestamp!)
            var timeEnding = "AM"
            var timestampHour = calendar.component(.hour, from: timestamp!)
            if timestampHour > 12 {
                let hourDifference = timestampHour - 12
                timestampHour = hourDifference
                timeEnding = "PM"
            }
            let timestampMinutes = calendar.component(.minute, from: timestamp!)
            if timestampMinutes < 10 {
                timestampTime = "\(timestampHour):0\(timestampMinutes) \(timeEnding)"
            } else {
                timestampTime = "\(timestampHour):\(timestampMinutes) \(timeEnding)"
            }
            timestampDate = "\(month!)/\(day!)/\(year!)"
        }
    
        
        if let user = dictionary["user"] as? NSDictionary {
            tweetUser = User(dictionary: user)
        }
        
        retweeted = dictionary["retweeted"] as? Bool
        retweeted_status = dictionary["retweeted_status"] as? Tweet // Not a field so it's returning nil
        favorited = dictionary["favorited"] as? Bool
        
        //Used for selecting specific tweet
        tweetId = dictionary["id"] as? Int
        tweetId_str = dictionary["id_str"] as? String
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        return dictionaries.map({ (dict) -> Tweet in
            Tweet(dictionary: dict)
        })
    }
    
}
