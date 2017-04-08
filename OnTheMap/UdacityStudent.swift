//
//  UdacityStudentLocation.swift
//  OnTheMap
//
//  Created by CarlJohan on 31/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import Foundation

struct UdacityStudent {
    
    // MARK: Properties
    
    var firstName: String = ""
    var lastName: String = ""
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var mapString: String? = ""
    var mediaURl: String? = ""
    var objectID: String = ""
    
    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
     init(dictionary: [String:AnyObject]) {
        
        firstName =  dictionary[UdacityClient.StudentLocationJSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityClient.StudentLocationJSONResponseKeys.LastName] as! String
        
        if let latitude = dictionary[UdacityClient.StudentLocationJSONResponseKeys.Latitude] as! Double? {
            self.latitude = latitude
        }
        
        if let longitude = dictionary[UdacityClient.StudentLocationJSONResponseKeys.Longitude] as! Double? {
            self.longitude = longitude
        }
        
        objectID = dictionary[UdacityClient.StudentLocationJSONResponseKeys.ObjectId] as! String
        
        if let mapString = dictionary[UdacityClient.StudentLocationJSONResponseKeys.MapString] as! String? {
            self.mapString = mapString
        }
        
        if let mediaURl = dictionary[UdacityClient.StudentLocationJSONResponseKeys.MediaURL] as! String? {
            self.mediaURl = mediaURl
        }
    
    }
    
    static func dataFromStudents(_ results: [[String:AnyObject]]) -> [UdacityStudent] {
        
        var StudentData = [UdacityStudent]()
        
        for result in results {
            StudentData.append(UdacityStudent(dictionary: result))
        }
        
        return StudentData
     }
}


