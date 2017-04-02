//
//  MapViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 31/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var students: [UdacityStudent] = [UdacityStudent]()
    var annotations: [MKPointAnnotation] = []

    
    @IBOutlet var PinButton: UIBarButtonItem!
    @IBOutlet var RefreshButton: UIBarButtonItem!
    @IBOutlet var MapView: MKMapView!
    @IBOutlet var LogoutButtonOutlet: UIBarButtonItem!
    @IBOutlet var BlackLoadingScreen: UIView!
    @IBOutlet var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ActivityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupMap { (succes, errorString) in
            if let errorString = errorString { print(errorString) }
        }
    }
    
    @IBAction func LogoutButtonAction(_ sender: Any) {
        
    }
    
    
    @IBAction func PinButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func RefreshButtonAction(_ sender: Any) {
        loading(true)
        
        self.setupMap { (succes, errorString) in
            self.loading(false)
        }
        
        
    }
    
    
    func isURlValid(_ url: String)-> Bool {
        let alert = UIAlertController(title: "Error", message: "Invalid Link", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        if url.contains("https://") {
            return true
        }
        
        self.present(alert, animated: true, completion: nil)
        return false
    }
    
    func loading(_ isLoading: Bool) {
        switch isLoading {
        case true:
            self.MapView.alpha = 0.4
            self.ActivityIndicator.startAnimating()
            self.RefreshButton.isEnabled = false
        case false:
            self.MapView.alpha = 1
            self.ActivityIndicator.stopAnimating()
            
            self.RefreshButton.isEnabled = true
        }
    }
    
    func setupMap(completionHandlerForSetupMap: @escaping (_ succes: Bool, _ errorString: String?) -> Void ) {
        self.annotations.removeAll()
        
        UdacityClient.sharedInstance().getStudentData { (succes, errorString) in
            DispatchQueue.main.async {
                
                if succes {
                    self.students = UdacityClient.sharedInstance().students
                    self.setupAnootations()
                    completionHandlerForSetupMap(true, nil)
                } else {
                    print(errorString!)
                    completionHandlerForSetupMap(false, errorString)
                    return
                }
                
            }
        }
    }
    
    
    func setupAnootations() {
        
        for student in self.students {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURl
            
            
            self.annotations.append(annotation)
        }
        self.MapView.addAnnotations(self.annotations)

    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            
            if let urlString = view.annotation?.subtitle! {
                
                if isURlValid(urlString) {
                    let mediaURl = URL(string: urlString)
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        
                        let urlRequest = URLRequest(url: mediaURl!)
                        let MapVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                        MapVC.urlRequest = urlRequest
                        
                        let webAuthNavigationController = UINavigationController()
                        webAuthNavigationController.pushViewController(MapVC, animated: false)
                        
                        DispatchQueue.main.async {
                            self.present(webAuthNavigationController, animated: true, completion: nil)
                            
                        }
                    
                    }
                
                }
            
            }
        }
        
    }
    
}

