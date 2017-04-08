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
    var locationText: String = ""
    var geocoder = CLGeocoder()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("locationTexttt: \(locationText)")
        //lort(locationText)
        //print("Location tekst: \(locationText)")
        

        self.geocoder.geocodeAddressString(locationText) { (placemark, error) in
            if error != nil { print("There was an error getting geoCodeAddress"); return }
            
            guard let placemark = placemark?[0] else { print("lort"); return }
            
            //self.addAnnotation(placemark)
            
            let latitude = placemark.location!.coordinate.latitude
            let longitude = placemark.location!.coordinate.longitude
            guard let map = self.MapView else { print("lorrrrt"); return }
            
            print("Latitude: \(latitude)")
            print("Longitude: \(longitude)")
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let span = MKCoordinateSpanMake(0.04, 0.04)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            map.addAnnotation(annotation)
            map.setRegion(region, animated: true)
            

        }
    }
    
    

    func lort (_ locationText: String) {
        print("Location tekst: \(locationText)")
        
        self.geocoder.geocodeAddressString(locationText) { (placemark, error) in
            if error != nil { print("There was an error getting geoCodeAddress"); return }
            
            guard let placemark = placemark?[0] else { print("lort"); return }
            
            //self.addAnnotation(placemark)
            
            let latitude = placemark.location!.coordinate.latitude
            let longitude = placemark.location!.coordinate.longitude
            guard let map = self.MapView else { print("lort"); return }
            
            print("Latitude: \(latitude)")
            print("Longitude: \(longitude)")
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            let span = MKCoordinateSpanMake(0.04, 0.04)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            map.addAnnotation(annotation)
            map.setRegion(region, animated: true)
            

        }
    }
    
    func addAnnotation(_ placemark: CLPlacemark) {
        let latitude = placemark.location!.coordinate.latitude
        let longitude = placemark.location!.coordinate.longitude
        guard let map = self.MapView else { print("lort"); return }
        
        print("Latitude: \(latitude)")
        print("Longitude: \(longitude)")
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        map.addAnnotation(annotation)
        map.setRegion(region, animated: true)

    }
    
    @IBAction func CreatePinButtonAction(_ sender: Any) {
        
        print("locationTextKnap:\(self.locationText)")
        
    }
    
    
}
