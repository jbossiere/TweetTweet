//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Julian Test on 2/7/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ADDING TWITTER LOGO TO NAV BAR
        let logo = UIImage(named: "TwitterLogo")
        let titleLogoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        titleLogoImageView.contentMode = .scaleAspectFit
        titleLogoImageView.image = logo
        self.navigationItem.titleView = titleLogoImageView
        self.navigationItem.titleView?.tintColor = UIColor.white
        
        //PULL TO REFRESH
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction(refreshControl :)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAfterTweeting), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    func refreshAfterTweeting(notification: Notification) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let navbarColor = "0x1DA0F2".hexColor
        self.navigationController?.navigationBar.barTintColor = navbarColor
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func refreshAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }


    
//     MARK: - Navigation

//    In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
            let tweetDetailViewController = segue.destination as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
            tweetDetailViewController.user = tweet.tweetUser
        
        } else if segue.identifier == "profileSegue" {
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
            
            let button = sender as! UIButton
            let tableViewContents = button.superview!
            let cell = tableViewContents.superview! as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.tweet = tweet
            profileViewController.user = tweet.tweetUser
        } else if segue.identifier == "composeSegue" {
            let composeViewController = segue.destination as! ComposeViewController
            composeViewController.user = User.currentUser
        }
    }
    

}
