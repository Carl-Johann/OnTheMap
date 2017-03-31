//
//  ViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 30/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var udacityLogo: UIImageView!
    @IBOutlet var loginFieldsStackView: UIStackView!
    
    @IBOutlet var loginTextLabel: UILabel!
    @IBOutlet var emailLoginTextField: UITextField!
    @IBOutlet var passwordLoginTextField: UITextField!
    @IBOutlet var loginButtonOutlet: UIButton!
    @IBOutlet var loadingDot: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingDot.alpha = 0
        // Do any additional setup after loading the view, typically from a nib.
    }



    
    @IBAction func loginButton(_ sender: UIButton) {
        loadingDot.startAnimating()
        loadingDot.alpha = 1
        print("LoginButton Clicked")
        UdacityClient.sharedInstance().getSessionID { (succes, errorString) in
            if succes {
                print("GetSessionID was a succes")
                self.performSegue(withIdentifier: "LoginToTabBarControllerSegue" , sender: self)
                print("Performed Segue")
                self.loadingDot.stopAnimating()
            }
        }
    }
    
    
}

