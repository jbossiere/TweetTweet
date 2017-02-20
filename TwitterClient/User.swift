//
//  User.swift
//  TwitterClient
//
//  Created by Julian Test on 2/6/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var profileBgUrl: URL?
    var tagline: String?
    var followersCount: Double?
    var followersCountString: String?
    var followingCount: Double?
    var followingCountString: String?
    var userIdString: String?
    var userColor: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        }
        if let profileBgString = dictionary["profile_background_image_url_https"] as? String {
            profileBgUrl = URL(string: profileBgString)
        }
        
        tagline = dictionary["description"] as? String
        
        //SET UP DISPLAYING FOLLOWERS COUNT
        followersCount = dictionary["followers_count"] as? Double
        if followersCount! >= 10000 {
            let shorten = followersCount! / 1000
            let rounded = (shorten*10).rounded() / 10
            followersCountString = String(rounded) + "K"
        } else if followersCount! >= 1000000 {
            let shorten = followersCount! / 1000000
            let rounded = (shorten*10).rounded() / 10
            followersCountString = String(rounded) + "M"
        } else {
            followersCountString = String(Int(followersCount!.rounded()))
        }
        //SET UP DISPLAYING FOLLOWING COUNT
        followingCount = dictionary["friends_count"] as? Double
        if followingCount! >= 10000 {
            let shorten = followingCount!/1000
            let rounded = (shorten*10).rounded() / 10
            followingCountString = String(rounded) + "K"
        } else if followingCount! >= 1000000 {
            let shorten = followingCount!/1000000
            let rounded = (shorten*10).rounded() / 10
            followingCountString = String(rounded) + "M"
        } else {
            followingCountString = String(Int(followingCount!.rounded()))
        }
        
        userIdString = dictionary["id_str"] as? String
        userColor = dictionary["profile_link_color"] as? String
    }
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "userDidLogout")
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
            
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
    
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
        
}
