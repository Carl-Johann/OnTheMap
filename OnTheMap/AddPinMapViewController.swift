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
    
    @IBOutlet var MapView: MKMapView!
    
    let placemark: CLPlacemark
    var geocoder = CLGeocoder()
    let locationText: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    init(_ placemark: CLPlacemark,_ locationText: String,_ mediaURL: String,_ latitude: Double,_ longitude: Double) {
        self.placemark = placemark
        self.mediaURL = mediaURL
        self.locationText = locationText
        self.latitude = latitude
        self.longitude = longitude
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            
            print("mediaURL: \(self.mediaURL)")
            print("locationText: \(self.locationText)")
            print("placemark: \(self.placemark)")
            print("latitude: \(self.latitude)")
            print("longitude: \(self.longitude)")
            
            

            guard let map = self.MapView else { print("lorrrrt"); return }
            
            let coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
            
            let span = MKCoordinateSpanMake(0.04, 0.04)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            map.addAnnotation(annotation)
            map.setRegion(region, animated: true)
            
        }
        
    }
    
    
    @IBAction func CreatePinButtonAction(_ sender: Any) {
        
        /*let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().accountKey)\", \"firstName\": \"Carl-Johan\", \"lastName\": \"Beurling\",\"mapString\": \"\(self.locationText)\", \"mediaURL\": \"\(self.mediaURL)\",\"latitude\": \(self.latitude), \"longitude\": \(self.longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { return }
        }
        task.resume()*/
        let mapViewVC = MapViewController()
        present(mapViewVC, animated: true, completion: nil)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
