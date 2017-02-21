//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Julian Test on 2/20/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {


    @IBOutlet weak var controlsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var userImageview: UIImageView!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageview.setImageWith(user.profileUrl!)
        userImageview.layer.cornerRadius = 5
        userImageview.clipsToBounds = true
        
        self.tweetTextView.delegate = self
        tweetTextView.textColor = UIColor.lightGray
        tweetButton.layer.cornerRadius = 5
    }
    
    @IBAction func onClose(_ sender: Any) {
        tweetTextView.resignFirstResponder()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //ADDS PLACEHOLDER TEXT TO UITEXTVIEW
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            tweetTextView.textColor = UIColor.lightGray
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ADDS OBSERVER TO KEYBOARD SHOWING AND HIDING AND SETS CONTROLSVIEW INITIAL POSITION
    var controlsViewInitialPosition: CGFloat = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        self.controlsViewInitialPosition = self.controlsView.frame.origin.y
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    //ADJUSTS THE POSITION OF THE CONTROLS VIEW DEPENDING ON WHETHER KEYBOARD IS SHOWING OR HIDDEN
    func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.controlsView.frame.origin.y = controlsViewInitialPosition - keyboardSize.height
                self.controlsBottomConstraint.constant = keyboardSize.height
            }
        }
    }
    func keyboardWillHide(notification: Notification) {
        self.controlsView.frame.origin.y = controlsViewInitialPosition
        controlsBottomConstraint.constant = 0.0
        view.setNeedsLayout()
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
