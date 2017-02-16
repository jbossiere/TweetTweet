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
    var timestampHour: Int?
    var retweetCount: Int = 0
    var favoritesCount: Int  = 0
    var profileUrl: URL?
    var name: String?
    var screenname: String?
    var retweeted: Bool?
    var retweeted_status: Tweet?
    var favorited: Bool?
    var id: Int?
    var id_str: String?
    
    
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
            let day = calendar.component(.day, from: timestamp!)
            let fullYear = calendar.component(.year, from: timestamp!)
            let year = fullYear - 2000
            let month = calendar.component(.month, from: timestamp!)
            timestampHour = calendar.component(.hour, from: timestamp!)
            if timestampHour! > 12 {
                let hour = timestampHour! - 12
                timestampHour = hour
            }
            let minutes = calendar.component(.minute, from: timestamp!)
            if minutes < 10 {
                timestampTime = "\(timestampHour!):0\(minutes)"
            } else {
                timestampTime = "\(timestampHour!):\(minutes)"
            }
            timestampDate = "\(month)/\(day)/\(year)"
        }
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        let user = dictionary["user"] as? NSDictionary
        if let user = user {
            
            name = user["name"] as? String
            screenname = user["screen_name"] as? String
            
            let profileUrlString = user["profile_image_url_https"] as? String
            profileUrl = URL(string: profileUrlString!)
            
        }
        
        retweeted = dictionary["retweeted"] as? Bool
        retweeted_status = dictionary["retweeted_status"] as? Tweet // Not a field so it's returning nil
//        print(dictionary)
//        print("retweeted_status: \(retweeted_status)")
        favorited = dictionary["favorited"] as? Bool
        
        id = dictionary["id"] as? Int
        id_str = dictionary["id_str"] as? String

        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
