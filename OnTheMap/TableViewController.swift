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
    
    @IBOutlet var pinDataTableView: UITableView!
    @IBOutlet var refreshButtonOutlet: UIBarButtonItem!
    @IBOutlet var addPinButtonOutlet: UIBarButtonItem!
    @IBOutlet var logoutButtonOutlet: UIBarButtonItem!
    var indicator = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTable()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinDataCell")!
        let StudentAtRow = self.students[indexPath[1]]
        let picture = UIImage(named: "icon_pin")
        
        cell.textLabel?.text = ("\(StudentAtRow.firstName! + " " + StudentAtRow.lastName!)")
        cell.detailTextLabel?.text = StudentAtRow.mediaURl
        cell.imageView?.image = picture
        
        return cell
    }
    
    
    func isURlValid(_ url: String)-> Bool {
        if url.contains("https://") { return true }
        
        presentError("URL is not valid")
        return false
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let StudentAtRow = self.students[indexPath[1]]
        
        if isURlValid(StudentAtRow.mediaURl!) {
            let mediaURl = URL(string: StudentAtRow.mediaURl!)
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                let urlRequest = URLRequest(url: mediaURl!)
                let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                webVC.urlRequest = urlRequest
                
                let webAuthNC = UINavigationController()
                webAuthNC.pushViewController(webVC, animated: false)
                
                DispatchQueue.main.async { self.present(webAuthNC, animated: true, completion: nil) }
            }
            
        }
        
    }
    
    
    
    
    @IBAction func logoutbuttonAction(_ sender: Any) {
        indicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            UdacityClient.sharedInstance.logout { (succes, error) in
                guard succes else { self.indicator.stopAnimating(); return }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.indicator.stopAnimating()
                }
                
            }
        }
    }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        indicator.startAnimating()
        updateTable()
    }
    
    func updateTable() {
        UdacityClient.sharedInstance.getStudentData(completionHandlerForStudentData: { (succes, errorString) in
            self.checkStudentForFirstName(completionHandlerForStudentsFirstName: { (succes, error) in
                guard error == nil else { print("lort"); return }
                DispatchQueue.main.async {
                    self.pinDataTableView.reloadData()
                    
                    self.indicator.stopAnimating()
                }
            })
        })

    }
    
    
    func checkStudentForFirstName(completionHandlerForStudentsFirstName: @escaping ( _ succes: Bool, _ error: String? ) -> Void) {
        //UdacityStudentsData.sharedInstance.students.removeAll()
        print("Students count: \(UdacityStudentsData.sharedInstance.students.count)")

        for student in UdacityStudentsData.sharedInstance.students {
            
            if student.firstName!.isEmpty { }
            else { students.append(student) }
            
        }
        
        completionHandlerForStudentsFirstName(true, nil)
    }
    
    
    func activityIndicator() {
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    
    func presentError(_ message: String, _ title: String = "Error", _ actionTitle: String = "OK") {
        self.present(UdacityClient.sharedInstance.raiseError(message, title, actionTitle), animated: true, completion: nil)
    }
}
