//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 06/04/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit
import MapKit

class AddPinViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var linkTextField: UITextField!
    @IBOutlet var findOnTheMapButton: UIButton!
    
    
    var geocoder = CLGeocoder()
    var locationText: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupTextField(locationTextField)
        setupTextField(linkTextField)
        
    }
    
    
    func setupTextField(_ Textfield: UITextField) {
        Textfield.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        Textfield.textColor = UIColor.lightGray
        Textfield.textAlignment = .center
        Textfield.delegate = self
        
    }
    
    
    
    @IBAction func findOnTheMapButton(_ sender: Any) {
        DispatchQueue.main.async {
            
            
            self.geocoder.geocodeAddressString(self.locationTextField.text!) { (placemark, error) in
                if error != nil { self.raiseError("Location Is Not Valid"); return }
                self.checkLinkTextField(self.linkTextField)
                
                guard let placemark = placemark?[0] else { return }
                guard let mediaURL = self.linkTextField.text else { return }
                guard let locationText = self.locationTextField.text else { return }
                let latitude = placemark.location!.coordinate.latitude
                let longitude = placemark.location!.coordinate.longitude
                
                self.mediaURL = mediaURL
                self.locationText = locationText
                self.latitude = latitude
                self.longitude = longitude
                
                self.performSegue(withIdentifier: "AddPinSegue", sender: self)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddPinSegue" {
            let AddPinVC = segue.destination as! AddPinMapViewController
            
            AddPinVC.latitude = latitude
            AddPinVC.longitude = longitude
            AddPinVC.locationText = locationText
            AddPinVC.mediaURL = mediaURL
            
        }
    }
    
    
    func checkLinkTextField(_ textField: UITextField) {
        if textField.text!.isEmpty { self.raiseError("A Link Should Be Entered") }
            
        else { if self.linkTextField.text!.contains("https://") { } else {
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
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

