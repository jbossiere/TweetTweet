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
    var user: User!
    var userId: String?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var userColorBannerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MAKES NAVBAR TRANSPARENT
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true

        userImageView.setImageWith(user.profileUrl!)
        userImageView.layer.cornerRadius = 5
        userImageView.layer.borderWidth = 4
        let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        userImageView.layer.borderColor = white.cgColor
        userImageView.clipsToBounds = true

        userNameLabel.text = user.name
        screennameLabel.text = "@\(user.screenname!)"
        taglineLabel.text = user.tagline
        followingNumLabel.text = user.followingCountString!
        followersNumLabel.text = user.followersCountString!
        
        userId = user.userIdString
        TwitterClient.sharedInstance?.getUserBanner(success: { (bannerDictionary: NSDictionary) in
            let images = bannerDictionary["sizes"] as? NSDictionary
            let mobileRetina = images?["600x200"] as? NSDictionary
            let bgImgUrlString = mobileRetina?["url"] as? String
            let bgImgUrl = URL(string: bgImgUrlString!)
            self.userColorBannerView.backgroundColor = nil
            self.bgImageView.setImageWith(bgImgUrl!)
        }, failure: { (error: Error) in
            let hexStarter = "0x"
            let hexString = hexStarter + self.user.userColor!
            let bgColor = hexString.hexColor
            self.userColorBannerView.backgroundColor = bgColor
        }, userId: userId!)

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

extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 255 / 255)
    }
}
