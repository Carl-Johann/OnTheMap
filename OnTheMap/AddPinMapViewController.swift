//
//  AddPinMapViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 08/04/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit
import MapKit

class AddPinMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var locationText: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            
            let coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
            
            let span = MKCoordinateSpanMake(0.04, 0.04)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            
        }
        
    }
    
    
    @IBAction func createPinButtonAction(_ sender: Any) {
        print("accountKey: \(UdacityClient.sharedInstance.accountKey)")
        print("fornavn: \(UdacityClient.sharedInstance.firstName)")
        print("efternavn: \(UdacityClient.sharedInstance.lastName)")
        self.activityIndicator.startAnimating()
        
        if checkIfUserHasAPin() {

            UdacityClient.sharedInstance.updateUserPinData(latitude, longitude, locationText, mediaURL) { (succes, errorString) in
                if errorString != nil {
                    self.presentError("An error occurred")
                    print("error: \(errorString!)")
                    self.activityIndicator.stopAnimating()
                    
                }
                
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
            
        } else {

            UdacityClient.sharedInstance.postPin(latitude, longitude, locationText, mediaURL) { (succes, errorString) in
                if errorString != nil {
                    self.presentError("An error occurred")
                    print("error: \(errorString!)")
                    self.activityIndicator.stopAnimating()
                }
                
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                
            }
            
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
