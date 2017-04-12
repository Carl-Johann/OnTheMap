//
//  UdacityClient.Constants.swift
//  OnTheMap
//
//  Created by CarlJohan on 30/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient : NSObject, UIAlertViewDelegate {
    
    var session = URLSession.shared
    
    //    var students: [UdacityStudent] = [UdacityStudent]()
    var sessionID: String? = ""
    let accountKey = 5608813109
    var firstName: String = ""
    var lastName: String = ""
    
    
    func getSessionID(_ username: String,_ password: String, completionHandlerForSessionID: @escaping (_ succes: Bool?, _ error: String? ) -> Void) {
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("Couldn't fetch sessionID")
                completionHandlerForSessionID(false, "An error occured")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForSessionID(false, "Email og password was incorrect")
                return
            }
            
            let range = Range(5 ..< data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let parsedResult = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
            
            guard let session = parsedResult["session"] as? [String:AnyObject] else {
                print("Couldn't find the 'session' ")
                completionHandlerForSessionID(false, "An error occured")
                return
            }
            
            guard let sessionID = session["id"] else { print("Couldn't fetch the session ID from 'parsedResult'"); return }
            self.sessionID = sessionID as? String
            
            
            completionHandlerForSessionID(true, nil)
        }
        
        task.resume()
        
    }
    
    func getStudentData(completionHandlerForStudentData: @escaping ( _ succes: Bool, _ error: String? ) -> Void) {
        
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(Constants.LimitNumber)?order\(Constants.AscOrder)")!)
        
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                completionHandlerForStudentData(false, "There was an error with GETting student Locations")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForStudentData(false, "Your request returned a status code other than 2xx!")
                return
            }
            
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("Couldn't find any results")
                completionHandlerForStudentData(false, "Couldn't find any results")
                return
            }
            let structuredStudentData = UdacityStudent.dataFromStudents(results)
            // self.students = structuredStudentData
            UdacityStudentsData.sharedInstance.students = structuredStudentData
            completionHandlerForStudentData(true, nil)
        }
        
        task.resume()
        
    }
    
    
    
    
    
    func logout(completionHandlerForLogout: @escaping ( _ succes: Bool, _ error: String? ) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerForLogout(false, error as! String?)
                return
            }
            completionHandlerForLogout(true, nil)
        }
        task.resume()
    }
    
    
    
    
    
    func postPin(_ latitude: Double, _ longitude: Double, _ locationText: String, _ mediaURL: String, completionHandlerForPostPin: @escaping ( _ succes: Bool, _ error: String? ) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance.accountKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationText)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error != nil) else { completionHandlerForPostPin(false, "\(error!)"); return }
            
            completionHandlerForPostPin(true, nil)
        }
        task.resume()
    }
    
    
    
    func getLoggedInUserData() {
        
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(accountKey)")!)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let parsedResult = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
            
            //print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            
        }
        task.resume()
    
    
    
    }
    
    
    func raiseError(_ message: String, _ title: String, _ actionTitle: String) -> UIAlertController {
        let invalidLinkAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        invalidLinkAlert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        
        return invalidLinkAlert
    }
    
    
    static let sharedInstance = UdacityClient()
    
}
