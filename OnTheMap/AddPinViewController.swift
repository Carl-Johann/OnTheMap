//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 06/04/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit
import MapKit

class AddPinViewController: UIViewController {
    
    
    @IBOutlet var TopGrayFieldText: UILabel!
    @IBOutlet var LocationTextField: UITextField!
    @IBOutlet var ButtomGrayField: UIView!
    @IBOutlet var FindOnTheMapButton: UIButton!
    @IBOutlet var LinkTextField: UITextField!
    @IBOutlet var CreatePinButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTextField(LocationTextField)
        setupTextField(LinkTextField)
        
    }
    
    
    func postPin() {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().accountKey)\", \"firstName\": \"Carl-Johan\", \"lastName\": \"Beurling\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
 
    
    func setupTextField(_ Textfield: UITextField) {
        Textfield.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        Textfield.textColor = UIColor.lightGray
        Textfield.textAlignment = .center
    }
    
    
        
    @IBAction func findOnTheMapButton(_ sender: Any) {
        print("ada")
        guard let locationText = LocationTextField!.text else {print("asdad"); return }
        
        let AddPinMapVC = AddPinMapViewController()
        AddPinMapVC.locationText = locationText
        navigationController?.pushViewController(AddPinMapVC, animated: true)
        //performSegue(withIdentifier: "lorteSegue", sender: self)
    }
    
    
    @IBAction func CreatePinButtonAction(_ sender: Any) {
        print("adsa")
    }
    
    
    @IBAction func CancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    
}

