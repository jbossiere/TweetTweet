//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Julian Test on 2/15/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var favNumLabel: UILabel!
    @IBOutlet weak var retweetNumLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.setImageWith(tweet.profileUrl!)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        tweetTextLabel.text = tweet.text
        usernameLabel.text = tweet.name
        screennameLabel.text = "@\(tweet.screenname!)"
        timestampLabel.text = "\(tweet.timestampDate!), \(tweet.timestampTime!)"
        
        favNumLabel.text = "\(tweet.favoritesCount)"
        retweetNumLabel.text = "\(tweet.retweetCount)"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
