//
//  TableViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 31/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var pinDataTableView: UITableView!
    @IBOutlet var refreshButtonOutlet: UIBarButtonItem!
    @IBOutlet var addPinButtonOutlet: UIBarButtonItem!
    @IBOutlet var logoutButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTable()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityStudentsData.sharedInstance.students.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinDataCell")!
        let StudentAtRow = UdacityStudentsData.sharedInstance.students[indexPath[1]]
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
        
        let StudentAtRow = UdacityStudentsData.sharedInstance.students[indexPath[1]]
        
        if isURlValid(StudentAtRow.mediaURl!) {
            let mediaURl = URL(string: StudentAtRow.mediaURl!)
            
            DispatchQueue.main.async { UIApplication.shared.open(mediaURl!, options: [:]) }
            
        }
    }
    
    
    
    
    @IBAction func logoutbuttonAction(_ sender: Any) {
        loadingIndicator.startAnimating()
        UdacityClient.sharedInstance.logout { (succes, error) in
            guard succes else { self.loadingIndicator.stopAnimating(); return }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.loadingIndicator.stopAnimating()
            }
            
        }
        
    }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        updateTable()
    }
    
    func updateTable() {
        loadingIndicator.startAnimating()
        refreshButtonOutlet.isEnabled = false
        UdacityClient.sharedInstance.getStudentData(completionHandlerForStudentData: { (succes, error) in
            if error != nil { self.presentError("An error occured"); self.loadingIndicator.stopAnimating()
                self.refreshButtonOutlet.isEnabled = true
                return
            }
            
            DispatchQueue.main.async {
                self.pinDataTableView.reloadData()
                self.loadingIndicator.stopAnimating()
                self.refreshButtonOutlet.isEnabled = true
            }
            
        })
        
    }
    
    @IBAction func AddPinButtonAction(_ sender: Any) {
        if checkIfUserHasAPin() {
            let firstName = UdacityUserData.sharedInstance.user.first!.firstName!
            let lastName = UdacityUserData.sharedInstance.user.first!.lastName!
            
            let invalidLinkAlert = UIAlertController(title: "", message: "User \"\(firstName) \(lastName)\" Has Already Posted a Student Location. Would You Like to Overwrite That Location?", preferredStyle: .alert)
            
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { UIAlertAction in
                self.performSegue(withIdentifier: "MapViewToAddPin", sender: self)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            invalidLinkAlert.addAction(overwriteAction)
            invalidLinkAlert.addAction(cancelAction)
            
            self.present(invalidLinkAlert, animated: true, completion: nil)
        } else {
            self.navigationController?.performSegue(withIdentifier: "TableViewToAddPin", sender: self)
        }
        

    }
    
    func checkIfUserHasAPin() -> Bool {
        if UdacityUserData.sharedInstance.user.isEmpty { return false }
        return true
    }
 
    func presentError(_ message: String, _ title: String = "Error", _ actionTitle: String = "OK") {
        self.present(UdacityClient.sharedInstance.raiseError(message, title, actionTitle), animated: true, completion: nil)
    }
}
