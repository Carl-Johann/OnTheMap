//
//  TableViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 31/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var students: [UdacityStudent] = [UdacityStudent]()
    
    @IBOutlet var PinDataTableView: UITableView!
    @IBOutlet var RefreshButtonOutlet: UIBarButtonItem!
    @IBOutlet var PinButtonOutlet: UIBarButtonItem!
    @IBOutlet var LogoutButtonOutlet: UIBarButtonItem!
    @IBOutlet var ActivityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.students = UdacityClient.sharedInstance().students

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.students.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PinDataCell")!
        let StudentAtRow = self.students[indexPath[1]]
        let picture = UIImage(named: "icon_pin")
        
        
        cell.textLabel?.text = ("\(StudentAtRow.firstName + " " + StudentAtRow.lastName)")
        cell.detailTextLabel?.text = StudentAtRow.mediaURl
        cell.imageView?.image = picture

        return cell
    }
    
    func isURlValid(_ url: String)-> Bool {
        let invalidLinkAlert = UIAlertController(title: "Error", message: "Invalid Link", preferredStyle: UIAlertControllerStyle.alert)
        invalidLinkAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        if url.contains("https://") {
            return true
        }
        
        self.present(invalidLinkAlert, animated: true, completion: nil)
        return false
    }

 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let StudentAtRow = self.students[indexPath[1]]
        
        if isURlValid(StudentAtRow.mediaURl) {
            let mediaURl = URL(string: StudentAtRow.mediaURl)
            
            DispatchQueue.global(qos: .userInteractive).async {
                
             let urlRequest = URLRequest(url: mediaURl!)
                let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                webVC.urlRequest = urlRequest
                
                let webAuthNavigationController = UINavigationController()
                webAuthNavigationController.pushViewController(webVC, animated: false)
                
                DispatchQueue.main.async {
                    self.present(webAuthNavigationController, animated: true, completion: nil)
                
                }
            }
            
        }
        
    }
    
    func updateTable() {
    
       /* UdacityClient.sharedInstance().getStudentData { (succes, errorString) in
            if succes { self.students = UdacityClient.sharedInstance().students }
        } */
        
    }
    
    
    @IBAction func LogoutbuttonAction(_ sender: Any) {
        
    }
    
    @IBAction func PinButtonAction(_ sender: Any) {
    }
    
    @IBAction func RefreshButtonAction(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            UdacityClient.sharedInstance().getStudentData { (succes, errorString) in
                if succes { self.students = UdacityClient.sharedInstance().students }
            }
        }
    }
    
    func loading(_ IsLoading: Bool) {
        switch IsLoading {
        case true:
            self.ActivityIndicator.startAnimating()
            self.RefreshButtonOutlet.isEnabled = false
        case false:
            self.ActivityIndicator.stopAnimating()
            self.RefreshButtonOutlet.isEnabled = true
        }
    }
    
}
