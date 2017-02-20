//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Julian Test on 2/8/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetNumLabel: UILabel!
    @IBOutlet weak var favorNumLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweetId: String?

    var tweet: Tweet! {
        didSet {
            
            //SETTING USER DATA
            let user = tweet.tweetUser!
            userImageView.setImageWith(user.profileUrl!)
            nameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenname!)"
            
            tweetTextLabel.text = tweet.text
            
            //SETTING TIME AND DATE OF TWEET
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            if tweet.year != year {
                timestampLabel.text = "• \(tweet.month!)/\(tweet.day!)/\(tweet.year!)"
            } else {
                if tweet.month != month {
                    timestampLabel.text = "• \(tweet.month!)/\(tweet.day!)/\(tweet.year!)"
                } else {
                    if tweet.day != day {
                        if day - tweet.day! < 7 {
                            timestampLabel.text = "• \(day - tweet.day!)d"
                        } else {
                            timestampLabel.text = "• \(tweet.month!)/\(tweet.day!)/\(tweet.year!)"
                        }
                    } else {
                        if tweet.hour != hour {
                            timestampLabel.text = "• \(hour - tweet.hour!)h"
                        } else {
                            timestampLabel.text = "• \(minute - tweet.minute!)m"
                        }
                    }
                }
            }
            
            if tweet.retweetCount != 0 {
                retweetNumLabel.text = "\(tweet.retweetCount)"
            }
            if tweet.favoritesCount != 0 {
                favorNumLabel.text = "\(tweet.favoritesCount)"
            }
            
            // SETTING FAVORITE AND RETWEET ICON
            if tweet.favorited == true {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
            } else {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
            }
            if tweet.retweeted == true {
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
            } else {
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: UIControlState.normal)
            }
            
            //Used for unfavoriting specific tweet
            tweetId = tweet.tweetId_str
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func onFavorite(_ sender: Any) {
        TwitterClient.sharedInstance?.favoriteTweet(success: { (tweet: Tweet) in
            self.favorNumLabel.text = "\(tweet.favoritesCount)"
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            self.unfavoriteTweet()
        }, tweetId: tweetId!)
    }
    
    func unfavoriteTweet() {
        TwitterClient.sharedInstance?.unfavoriteTweet(success: { (tweet: Tweet) in
            self.favorNumLabel.text = "\(tweet.favoritesCount)"
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        }, tweetId: tweetId!)
    }
    
    @IBAction func onRT(_ sender: Any) {
        TwitterClient.sharedInstance?.retweetTweet(success: { (tweet: Tweet) in
            self.retweetNumLabel.text = "\(tweet.retweetCount)"
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            self.unretweetTweet()
        }, tweetId: tweetId!)
    }
    
    func unretweetTweet() {
        TwitterClient.sharedInstance?.unretweetTweet(tweet: self.tweet, success: { (tweet: Tweet) in
//            <#code#>
        }, failure: { (error: Error) in
            print("error: \(error)")
        })
    }
}
