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
    
    @IBOutlet var PinButton: UIBarButtonItem!
    @IBOutlet var RefreshButton: UIBarButtonItem!
    @IBOutlet var MapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func LogoutButtonAction(_ sender: Any) {
        print("lrt")
    }
    
    
}
