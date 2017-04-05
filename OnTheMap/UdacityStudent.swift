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
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURl: String
    let objectID: String
    
    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
     init(dictionary: [String:AnyObject]) {
        
        firstName =  dictionary[UdacityClient.StudentLocationJSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityClient.StudentLocationJSONResponseKeys.LastName] as! String
        latitude = dictionary[UdacityClient.StudentLocationJSONResponseKeys.Latitude] as! Double
        longitude = dictionary[UdacityClient.StudentLocationJSONResponseKeys.Longitude] as! Double
        objectID = dictionary[UdacityClient.StudentLocationJSONResponseKeys.ObjectId] as! String
        
        if dictionary[UdacityClient.StudentLocationJSONResponseKeys.MapString] is String {
            mapString = dictionary[UdacityClient.StudentLocationJSONResponseKeys.MapString] as! String
        } else {
            print("mapString's value was set to ' \("") ' due to not being returned a String")
            mapString = ""
        }
        
        if dictionary[UdacityClient.StudentLocationJSONResponseKeys.MediaURL] is String {
            mediaURl = dictionary[UdacityClient.StudentLocationJSONResponseKeys.MediaURL] as! String
        } else {
            print("mediaURl value was set to ' \("") ' due to not being returned a String")
            mediaURl = ""
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


