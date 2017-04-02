//
//  UdacityClient.Constants.swift
//  OnTheMap
//
//  Created by CarlJohan on 30/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {

    var session = URLSession.shared
    
    var students: [UdacityStudent] = [UdacityStudent]()
    var sessionID: String? = nil
    var accountKey: Int? = nil
    
    
    
    func getSessionID( completionHandlerForSessionID: @escaping (_ succes: Bool, _ error: String? ) -> Void) {

        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = "{\"udacity\": {\"username\": \"carljohan.beurling@gmail.com\", \"password\": \"joeercool2\"}}".data(using: String.Encoding.utf8)

        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in

            if error != nil { // Handle error…
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }

            let range = Range(5 ..< data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */

            let parsedResult = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject

            /* if let account = parsedResult["account"] as? [String:AnyObject] {
                if let accountKey = account["key"] as? Int {
                    self.accountKey = accountKey
                }
            } */

            if let session = parsedResult["session"] as? [String:AnyObject] {

                if let sessionID = session["id"] {

                    self.sessionID = sessionID as? String
                }
            } else {
                completionHandlerForSessionID(false, "There was an error with getting the sessionID from Udacity's servers")
            }
            
            completionHandlerForSessionID(true, nil)
        }

        task.resume()

    }

    func getStudentData(completionHandlerForStudentData: @escaping ( _ succes: Bool, _ error: String? ) -> Void) {
        
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with GETting student Locations")
                completionHandlerForStudentData(false, "There was an error with GETting student Locations")
                return
            }
            
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("Couldn't find any results")
                completionHandlerForStudentData(false, "Couldn't find any results")
                return
            }
            let structuredStudentData = UdacityStudent.dataFromStudents(results)
            self.students = structuredStudentData
            completionHandlerForStudentData(true, nil)
        }
        
        task.resume()
        
    }
    
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

}
