//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Julian Test on 2/7/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "exMezX94UWh5F4I5IiimAdA5z", consumerSecret: "vVBIu6X7zg1nFMkbEr3yDTyzEsxj2Cismo6L8Go93cYxc7hqUk")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    var tweets: [Tweet]!
    var id: Int?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        // clears keychains of preivous sessions
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclient://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }, failure: {(error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error:Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    // returns the authenticated user's home timeline
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as? [NSDictionary]
            
            self.tweets = Tweet.tweetsWithArray(dictionaries: dictionaries!)

            success(self.tweets!)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    // Gets the current user
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)

        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    // favorites a tweet on behalf of the authenticated user
    func favoriteTweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetId: String) {
        
        post("1.1/favorites/create.json", parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dicionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dicionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unfavoriteTweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetId: String) {
        
        post("1.1/favorites/destroy.json", parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweetTweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetId: String) {
        post("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            tweet.retweeted = true
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweetTweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var originalTweetId = ""
        print("can I unretweet? \(tweet.retweeted)")
        if tweet.retweeted == false {
            print("error: cannot unretweet tweet that has not been retweeted")
        } else {
            print(tweet.retweeted_status)
            if tweet.retweeted_status == nil {
                originalTweetId = tweet.tweetId_str!
            } else {
                originalTweetId = (tweet.retweeted_status?.tweetId_str!)!
            }
        }
        print("https://api.twitter.com/1.1/statuses/show/\(originalTweetId)json?include_my_retweet=1")
        //TODO: FIGURE OUT WHY THE GET IS FAILING
//        let fullTweet = get("https://api.twitter.com/1.1/statuses/show/\(originalTweetId)json?include_my_retweet=1", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
////            print(response)
//            let current_user_retweet = response
//            print("current user retweet: \(current_user_retweet)")
////            let retweetId = fullTweet.current_user_retweet.id_str
//        }) { (task: URLSessionDataTask?, error: Error) in
//            failure(error)
//        }
    }
    
    func getUserBanner(success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> (), userId: String) {
        get("1.1/users/profile_banner.json", parameters: ["user_id": userId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let bannerDictionary = response as? NSDictionary {
//                print(bannerDictionary)
                success(bannerDictionary)
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })

    }
    
    func postTweet(success: @escaping () -> (), failure: @escaping (Error) -> (), status: String) {
        post("1.1/statuses/update.json", parameters: ["status": status], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("successfully posted tweet! \(status)")
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
    }
    
}
