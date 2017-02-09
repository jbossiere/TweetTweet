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
        }
    }
    var user: User! {
        didSet {
            
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

}
