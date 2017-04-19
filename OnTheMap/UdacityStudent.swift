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
    
    var createdAt: String? = ""
    var firstName: String? = "Unkown"
    var lastName: String? = "Name"
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var mapString: String? = ""
    var mediaURl: String? = ""
    var objectID: String? = ""
    var uniqueKey: String? = ""
    var updatedAt: String? = ""
    
    
    // MARK: Initializers
    
     init(dictionary: [String:AnyObject]) {
        
        if let createdAt = dictionary[UdacityClient.StudentLocationJSONResponseKeys.CreatedAt ] as? String { self.createdAt = createdAt }
        
        if let firstName = dictionary[UdacityClient.StudentLocationJSONResponseKeys.FirstName] as? String { self.firstName = firstName }
        
        if let lastName = dictionary[UdacityClient.StudentLocationJSONResponseKeys.LastName] as? String { self.lastName = lastName}
        
        if let latitude = dictionary[UdacityClient.StudentLocationJSONResponseKeys.Latitude] as? Double { self.latitude = latitude }
        
        if let longitude = dictionary[UdacityClient.StudentLocationJSONResponseKeys.Longitude] as? Double { self.longitude = longitude }
        
        if let objectID = dictionary[UdacityClient.StudentLocationJSONResponseKeys.ObjectId] as? String { self.objectID = objectID }
        
        if let mapString = dictionary[UdacityClient.StudentLocationJSONResponseKeys.MapString] as? String { self.mapString = mapString }
        
        if let uniqueKey = dictionary[UdacityClient.StudentLocationJSONResponseKeys.UniqueKey] as? String { self.uniqueKey = uniqueKey }
        
        if let mediaURl = dictionary[UdacityClient.StudentLocationJSONResponseKeys.MediaURL] as? String { self.mediaURl = mediaURl }
        
        if let updatedAt = dictionary[UdacityClient.StudentLocationJSONResponseKeys.UpdatedAt] as? String { self.updatedAt = updatedAt }

    }
    
    static func dataFromStudents(_ results: [[String:AnyObject]]) -> [UdacityStudent] {
        
        var StudentData = [UdacityStudent]()
        
        for result in results { StudentData.append(UdacityStudent(dictionary: result)) }
        
        return StudentData
     }
}


