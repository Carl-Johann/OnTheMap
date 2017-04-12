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
        /* let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
         request.httpMethod = "POST"
         request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
         request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance.accountKey)\", \"firstName\": \"Carl-Johan\", \"lastName\": \"Beurling\",\"mapString\": \"\(self.locationText)\", \"mediaURL\": \"\(self.mediaURL)\",\"latitude\": \(self.latitude), \"longitude\": \(self.longitude)}".data(using: String.Encoding.utf8)
         let session = URLSession.shared
         let task = session.dataTask(with: request as URLRequest) { data, response, error in
         if error != nil {print(error!); return }
         }
         task.resume()*/
        
        UdacityClient.sharedInstance.postPin(latitude, longitude, locationText, mediaURL) { (succes, errorString) in
            guard (errorString != nil) else {
                self.presentError("An error occurred")
                print("error: \(errorString!)")
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
    func presentError(_ message: String, _ title: String = "Error", _ actionTitle: String = "OK") {
        self.present(UdacityClient.sharedInstance.raiseError(message, title, actionTitle), animated: true, completion: nil)
    }
    
    
}
