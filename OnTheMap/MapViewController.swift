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
        
        UdacityClient.sharedInstance.getUserData { (succes) in
            if succes { UdacityClient.sharedInstance.getLoggedInUserData() }
            else { self.presentError("An error occured") }
        }
        
        
        // print("\nIn MapViewController.viewDidLoad()..." )
        // print("\tUdacityClient.sharedInstance().firstName: \(UdacityClient.sharedInstance.firstName)")
        // print("\tUdacityClient.sharedInstance().lastName: \(UdacityClient.sharedInstance.lastName)")
        
        
        
    }
    
    // MARK: TODO save firstName and lastName to a userStudentLocation using UdacityStudent struct
    // MARK: TODO get user's studentLocation from Parse
    /*
     if an array of student location exists - find the latest student location  (create date is the latest)
     save object id to userStudentLocation
     - objectID will be used when adding/updating student  location
     else - set object to ""
     */
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.mapView.removeAnnotations(studentAnnotations)
        self.studentAnnotations.removeAll()
        self.setupMap { (succes, errorString) in
            if errorString != nil { self.presentError("An error occured") }
        }
        
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
    
    @IBAction func addPinButton(_ sender: Any) {
        
        if checkIfUserHasAPin() {
            let firstName = UdacityUserData.sharedInstance.user.first!.firstName!
            let lastName = UdacityUserData.sharedInstance.user.first!.lastName!
            
            let invalidLinkAlert = UIAlertController(title: "", message: "User \"\(firstName) \(lastName)\" Has Already Posted a Student Location. Would You Like to Overwrite That Location?", preferredStyle: .alert)
            
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { UIAlertAction in
                self.performSegue(withIdentifier: "MapViewToAddPin", sender: self)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            invalidLinkAlert.addAction(overwriteAction)
            invalidLinkAlert.addAction(cancelAction)
            
            self.present(invalidLinkAlert, animated: true, completion: nil)
        } else {
            self.navigationController?.performSegue(withIdentifier: "MapViewToAddPin", sender: self)
        }
        
    }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        loading(true)
        self.mapView.removeAnnotations(studentAnnotations)
        self.studentAnnotations.removeAll()
        self.setupMap { (succes, errorString) in
            if errorString != nil { self.presentError(errorString!) }
            self.loading(false)
        }
    }
    
    
    func isURlValid(_ url: String)-> Bool {
        
        if url.contains("https://") { return true }
        
        self.presentError("Invalid URL", "Error", "OK")
        return false
    }
    
    
    func setupMap(completionHandlerForSetupMap: @escaping (_ succes: Bool, _ errorString: String?) -> Void ) {
        
        UdacityClient.sharedInstance.getStudentData { (succes, errorString) in
            DispatchQueue.main.async {
                
                if succes {
                    self.setupAnnotations { (succes) in
                        completionHandlerForSetupMap(true, nil)
                    }
                    
                } else {
                    print(errorString!)
                    completionHandlerForSetupMap(false, errorString)
                    return
                }
                
            }
        }
        
    }
    
    
    func setupAnnotations(CHForSetupAnnotations: @escaping (_ succes: Bool) -> Void ) {
        
        for student in UdacityStudentsData.sharedInstance.students {
            
            let lat = CLLocationDegrees(student.latitude!)
            let long = CLLocationDegrees(student.longitude!)
            
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName!) \(student.lastName!)"
            annotation.subtitle = student.mediaURl!
            
            
            self.studentAnnotations.append(annotation)
        }
        self.mapView.addAnnotations(self.studentAnnotations)
        CHForSetupAnnotations(true)
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
    
    func checkIfUserHasAPin() -> Bool {
        if UdacityUserData.sharedInstance.user.isEmpty { return false }
        return true
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

