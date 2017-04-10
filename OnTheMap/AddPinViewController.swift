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
    
    
    @IBOutlet var LocationTextField: UITextField!
    @IBOutlet var LinkTextField: UITextField!
    @IBOutlet var FindOnTheMapButton: UIButton!
    
    let geocoder = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTextField(LocationTextField)
        setupTextField(LinkTextField)
        
    }
    
    
    func setupTextField(_ Textfield: UITextField) {
        Textfield.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        Textfield.textColor = UIColor.lightGray
        Textfield.textAlignment = .center
    }
    
    
    
    @IBAction func findOnTheMapButton(_ sender: Any) {
        
        self.geocoder.geocodeAddressString(self.LocationTextField.text!) { (placemark, error) in
            if error != nil { self.raiseError("Location Is Not Valid"); return }
            self.checkLinkTextField(self.LinkTextField)
            
            guard let placemark = placemark?[0] else { return }
            guard let mediaURL = self.LinkTextField.text else { return }
            guard let locationText = self.LocationTextField.text else { return }
            let latitude = placemark.location!.coordinate.latitude
            let longitude = placemark.location!.coordinate.longitude
            
            
            let AddPinMapVC = AddPinMapViewController(placemark, locationText, mediaURL, latitude, longitude)
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(AddPinMapVC, animated: true)
            }
        }
        
    }
    
    
    
    func checkLinkTextField(_ textField: UITextField) {
        if textField.text!.isEmpty { self.raiseError("A Link Should Be Entered") }
            
        else { if self.LinkTextField.text!.contains("https://") { } else {
            self.raiseError("Link not safe (https://)") }
        }
    }
    
    
    func raiseError(_ message: String) {
        DispatchQueue.main.async {
            let invalidLinkAlert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            invalidLinkAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(invalidLinkAlert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func CancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

