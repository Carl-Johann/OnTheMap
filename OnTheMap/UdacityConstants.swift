//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by CarlJohan on 30/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import Foundation


extension UdacityClient {
    
    struct Constants {
    
        static let accountKey = 5608813109
        
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let LimitNumber = 1
        static let DescUpdatedAt = "-updatedAt"
        static let AscUpdatedAt = "updatedAt"
        
        static let AscCreatedAt = "createdAt"
        static let DescCreatedAt = "-createdAt"
        
    }
    
    struct StudentLocationJSONResponseKeys {
        
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        
    }

}
