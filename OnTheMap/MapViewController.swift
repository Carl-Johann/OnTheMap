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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupMap()
        
        
    }
    
    @IBAction func LogoutButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func PinButtonAction(_ sender: Any) {
    }
    
    @IBAction func RefreshButtonAction(_ sender: Any) {
    }
    
    func setupMap() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            UdacityClient.sharedInstance().getStudentData { (students, succes, errorString) in

                DispatchQueue.main.async {

                    if succes {

                        self.students = students!
                    }

                    
                
                    for student in self.students {
                        let lat = CLLocationDegrees(student.latitude)
                        let long = CLLocationDegrees(student.longitude)

                        
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(student.firstName) \(student.lastName)"
                        annotation.subtitle = student.mediaURl
                        
                         // Finally we place the annotation in an array of annotations
                        self.annotations.append(annotation)
                    }
                    self.MapView.addAnnotations(self.annotations)
                  
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}
