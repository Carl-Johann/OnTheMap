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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        guard (self.mapView != nil) else {
            print("couldn't load map")
            self.presentError("An error occured while loading the map")
            return
        }
        
    }
    
    
    @IBAction func createPinButtonAction(_ sender: Any) {
        print("accountKey: \(UdacityClient.sharedInstance.accountKey)")
        self.activityIndicator.startAnimating()

        
        UdacityClient.sharedInstance.postPin(latitude, longitude, locationText, mediaURL) { (succes, errorString) in
            if succes {
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.presentError("An error occurred")
            self.present(UdacityClient.sharedInstance.raiseError("An error occurred", "Error", "OK"), animated: true, completion: nil)
            print("error: \(errorString!)")
            self.activityIndicator.stopAnimating()
            
        }
    }
    
    
    
    func presentError(_ message: String, _ title: String = "Error", _ actionTitle: String = "OK") {
        self.present(UdacityClient.sharedInstance.raiseError(message, title, actionTitle), animated: true, completion: nil)
    }
    
    
    
    
}
