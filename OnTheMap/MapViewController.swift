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
    
    var studentAnnotations: [MKPointAnnotation] = []
    
    @IBOutlet var pinButton: UIBarButtonItem!
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var logoutButtonOutlet: UIBarButtonItem!
    @IBOutlet var blackLoadingScreen: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.sharedInstance.getLoggedInUserData { (succes, errorString) in
            if succes {
                self.setupMap { (succes, errorString) in
                    if errorString != nil { self.presentError("An error occured"); return }
                }
            } else { print("error: \(errorString!)")}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        loading(true)
        DispatchQueue.global(qos: .userInitiated).async {
            UdacityClient.sharedInstance.logout { (succes, error) in
                if succes { DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil) }
                    self.loading(false)
                }
            }
        }
    }
    
    
    
    
    @IBAction func refreshButton(_ sender: Any) {
        loading(true)
        self.setupMap { (succes, errorString) in
            if errorString != nil { self.presentError(errorString!) }
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
    
    
    func setupMap(completionHandlerForSetupMap: @escaping (_ succes: Bool, _ errorString: String?) -> Void ) {
        studentAnnotations.removeAll()
        
        UdacityClient.sharedInstance.getStudentData { (succes, errorString) in
            DispatchQueue.main.async {
                
                if succes {
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
        self.mapView.removeAnnotations(studentAnnotations)
        
        for student in UdacityStudentsData.sharedInstance.students {
            
            let lat = CLLocationDegrees(student.latitude!)
            let long = CLLocationDegrees(student.longitude!)
            guard let firstname = student.firstName else { print("intet navn"); return }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstname) \(student.lastName!)"
            annotation.subtitle = student.mediaURl!
            
            
            self.studentAnnotations.append(annotation)
        }
        self.mapView.addAnnotations(self.studentAnnotations)
        
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
        
        guard control == view.rightCalloutAccessoryView else { return }
        
        guard let urlString = view.annotation?.subtitle! else { return }
        
        guard isURlValid(urlString) else { return }
        
        guard let mediaURl = URL(string: urlString) else { return }
        
        DispatchQueue.main.async { UIApplication.shared.open(mediaURl, options: [:]) }
        
    }
    
    
    func loading(_ isLoading: Bool) {
        switch isLoading {
        case true:
            self.mapView.alpha = 0.4
            self.activityIndicator.startAnimating()
            self.refreshButton.isEnabled = false
        case false:
            self.mapView.alpha = 1
            self.activityIndicator.stopAnimating()
            self.refreshButton.isEnabled = true
        }
    }
    
    func presentError(_ message: String, _ title: String = "Error", _ actionTitle: String = "OK") {
        self.present(UdacityClient.sharedInstance.raiseError(message, title, actionTitle), animated: true, completion: nil)
    }
    
}

