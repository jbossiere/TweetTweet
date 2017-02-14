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
            tweetTextLabel.text = tweet.text
            userImageView.setImageWith(tweet.profileUrl!)
            nameLabel.text = tweet.name
            screenNameLabel.text = "@\(tweet.screenname!)"
            
            let date = NSDate()
            let calendar = NSCalendar.current
            let currentHour = calendar.component(.hour, from: date as Date)
            timestampLabel.text = "• \(tweet.combinedTimestamp!)"
            
            if tweet.retweetCount != 0 {
                retweetNumLabel.text = "\(tweet.retweetCount)"
            }
            if tweet.favoritesCount != 0 {
                favorNumLabel.text = "\(tweet.favoritesCount)"
            }
            
            // Set favorite and retween icon depending on whether it has been favorited
            // or retweeted
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
            
            tweetId = tweet.id_str
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
            print("retweeted 1")
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
