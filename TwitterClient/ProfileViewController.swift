//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Julian Test on 2/15/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello, \(tweet.name!)")
        let user = tweet.user!
        print("user: \(user)")
        let name = user["name"] as? String
        print("hello hellow, \(name)")

        // Do any additional setup after loading the view.
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
