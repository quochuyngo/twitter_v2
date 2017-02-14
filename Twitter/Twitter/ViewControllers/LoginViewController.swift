//
//  LoginViewController.swift
//  Twitter
//
//  Created by Quoc Huy Ngo on 2/8/17.
//  Copyright © 2017 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signInAction(_ sender: Any) {

        TwitterClient.shareInstance.login(success: {
            TwitterClient.shareInstance.getUserInfo(success: { (user) in
                User.currentUser = user
                print(user.screenName!)
                self.performSegue(withIdentifier: "timeLineSegue", sender: nil)
            })
            
        }, failure: { (error) in
            print(error)
        })
    }
}
