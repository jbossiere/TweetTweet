//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Julian Test on 2/20/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user.name)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClose(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
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
