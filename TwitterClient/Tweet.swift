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
    var combinedTimestamp: String?
    var retweetCount: Int = 0
    var favoritesCount: Int  = 0
    var profileUrl: URL?
    var name: String?
    var screenname: String?
    var retweeted: Bool?
    var favorited: Bool?
    var id: Int?
    
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
            let year = calendar.component(.year, from: timestamp!)
            let month = calendar.component(.month, from: timestamp!)
            combinedTimestamp = "\(month)/\(day)/\(year)"
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
            
//            favoritesCount = (user["favourites_count"] as? Int) ?? 0
//            print(favoritesCount)
        }
        
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
        id = dictionary["id"] as? Int
        
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
