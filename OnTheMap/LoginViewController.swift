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
        print("1")
        DispatchQueue.global(qos: .userInitiated).async {
            print("2")
            UdacityClient.sharedInstance().getSessionID { (succes, errorString) in
                print("3")
                DispatchQueue.main.async {
                    print("4")
                    if succes {
                        print("5")
                        self.performSegue(withIdentifier: "LoginToTabBarControllerSegue" , sender: self)
                        print("6")
                    }
                }
              self.loadingDot.stopAnimating()
            }
        }
    }
    
    
}

