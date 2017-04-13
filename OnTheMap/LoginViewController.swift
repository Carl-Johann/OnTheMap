//
//  ViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 30/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var udacityLogo: UIImageView!
    @IBOutlet var emailLoginTextField: UITextField!
    @IBOutlet var passwordLoginTextField: UITextField!
    @IBOutlet var loginButtonOutlet: UIButton!
    @IBOutlet var loadingDot: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupTextField(emailLoginTextField)
        self.setupTextField(passwordLoginTextField)
        
    }
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        guard areTextFieldsEmpty() else { return }
        guard let username = emailLoginTextField.text else { return }
        guard let password = passwordLoginTextField.text else { return }
        
        UdacityClient.sharedInstance.getSessionID(username, password) { (succes, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.loading(false)
                    self.presentError(error!, "Error", "Try Agian")
                    return
                }
                
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                self.loading(false)
            }
            
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
        
        let MapVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        MapVC.urlRequest = URLRequest(url: url!)
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(MapVC, animated: false)
        
        DispatchQueue.main.async {
            self.present(webAuthNavigationController, animated: true, completion: nil)
        }
    }

    
    
    func areTextFieldsEmpty()-> Bool {
        if (emailLoginTextField.text?.isEmpty)! || (passwordLoginTextField.text?.isEmpty)! {
            self.presentError("Enter a password and email")
            loading(false)
            return false
        }
    
        loading(true)
        return true
    }
    
    
    func loading(_ isLoading: Bool) {
        switch isLoading {
        case true:
            loadingDot.startAnimating()
            loginButtonOutlet.isHidden = true
        case false:
            loadingDot.stopAnimating()
            loginButtonOutlet.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupTextField(_ textfield: UITextField) {
        textfield.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        textfield.textColor = UIColor.black.withAlphaComponent(0.8)
        textfield.textAlignment = .left
        textfield.layer.borderColor = UIColor.gray.cgColor
        textfield.layer.borderWidth = 1.5
        textfield.layer.cornerRadius = 5
        textfield.delegate = self
        
    }
    
    func presentError(_ message: String, _ title: String = "Error", _ actionTitle: String = "OK") {
        self.present(UdacityClient.sharedInstance.raiseError(message, title, actionTitle), animated: true, completion: nil)
    }
    
}

