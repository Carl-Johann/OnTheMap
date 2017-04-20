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
    
    var currentUser = UdacityUserData.sharedInstance.user
    var session = URLSession.shared
    
    var accountKey: String = ""
    var sessionID: String = ""
    var objectID: String = ""
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
            
            guard let account = parsedResult["account"] as? [String:AnyObject] else {
                print("Couldn't find the 'account' in parse")
                completionHandlerForSessionID(false, "An error occured")
                return
            }
            
            guard let accountKey = account["key"] as? String else { print("Couldn't fetch the key from 'account'"); return}
            guard let sessionID = session["id"] as? String else { print("Couldn't fetch the session ID from 'parsedResult'"); return }
            
            self.accountKey = accountKey
            self.sessionID = sessionID
            
            
            completionHandlerForSessionID(true, nil)
        }
        
        task.resume()
        
    }
    
    
    
    
    
    func getStudentData(completionHandlerForStudentData: @escaping ( _ succes: Bool, _ error: String? ) -> Void) {
        UdacityStudentsData.sharedInstance.students.removeAll()

        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=\(Constants.DescUpdatedAt)")!)
        
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with GETting student Locations")
                completionHandlerForStudentData(false, "An error occured")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForStudentData(false, "An error occured")
                return
            }
            
            let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("Couldn't find any results")
                completionHandlerForStudentData(false, "Couldn't find any results")
                return
            }
            
            let structuredStudentData = UdacityStudent.dataFromStudents(results)
            
            UdacityStudentsData.sharedInstance.students.append(contentsOf: structuredStudentData)
            
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
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.httpBody = "{\"uniqueKey\": \"\(self.accountKey)\", \"firstName\": \"\(currentUser[0].firstName!)\", \"lastName\": \"\(currentUser[0].lastName!)\",\"mapString\": \"\(locationText)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
         if error != nil { completionHandlerForPostPin(false, "An error occured creating your pin") }
         
         completionHandlerForPostPin(true, nil)
         
         }
         
         task.resume()
    }
    
    
    
    
    
    func getLoggedInUserData() {
        DispatchQueue.global(qos: .background).async {
            print("6")
            
            let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(self.accountKey)")!)
            
            let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil { print("error: \(error!)"); return }
                
                print("7")
                let range = Range(uncheckedBounds: (5, data!.count))
                let newData = data?.subdata(in: range)
                
                let parsedResult = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                
                // print("\nin UdacityClient.getLoggedInUserData...")
                // print("\tgetLoggedInUserData: \(parsedResult)")
                
                guard let user = parsedResult["user"] as? [String:AnyObject] else { print("couldn't retrive parsed result"); return }
                
                guard let firstName = user["first_name"] as? String else { print("couldn't retrive 'firstName' from 'parsedResult'"); return }
                
                guard let lastName = user["last_name"] as? String else { print("couldn't retrive 'lastName' from 'parsedResult'"); return }
                
                print("firstName: \(firstName)")
                print("lastName: \(lastName)")
                
                self.firstName = firstName
                self.lastName = lastName
                
            }
            task.resume()
            
        }
        
    }
    
    
    
    

    func updateUserPinData(_ latitude: Double, _ longitude: Double,_ mapSting: String, _ mediaURL: String, CHForUserPinData: @escaping ( _ succes: Bool, _ errorString: String? ) -> Void) {

        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(self.objectID)"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "PUT"
        
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        
        request.httpBody = "{\"uniqueKey\": \"\(self.accountKey)\", \"firstName\": \"\(self.firstName)\", \"lastName\": \"\(self.lastName)\",\"mapString\": \"\(mapSting)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { print("Error at UdacityClient.swift 230: \(error!)");CHForUserPinData(false, "An error occured"); return }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("UdacityClient.swift 253: Your request returned a status code other than 2xx!")
                CHForUserPinData(false, "An error occured")
                return
            }
            
            CHForUserPinData(true, nil)
            
        }
        task.resume()
        
    }
    
    
    
    
    
    func getUserData(CHForUserData: @escaping (_ succes: Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            
            let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(self.accountKey)%22%7D&order=\(Constants.DescCreatedAt)&limit=\(Constants.LimitNumber)"
            
            let url = URL(string: urlString)
            let request = NSMutableURLRequest(url: url!)
            
            request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.RestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            
            
            let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil { print("error: \(error!)"); CHForUserData(false); return }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("UdacityClient.swift 253: Your request returned a status code other than 2xx!")
                    CHForUserData(false)
                    return
                }
                
                
                let parsedResult = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                
                guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                    print("UdacityClient.swift 261: Couldn't find any results")
                    CHForUserData(false)
                    return
                }
                
                UdacityUserData.sharedInstance.user = UdacityStudent.dataFromStudents(results)
                self.objectID = UdacityUserData.sharedInstance.user.first!.objectID!
                CHForUserData(true)
            }
            task.resume()
        
        }
    }
    
    
    
    
    
    func raiseError(_ message: String, _ title: String, _ actionTitle: String) -> UIAlertController {
        let invalidLinkAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        invalidLinkAlert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        
        return invalidLinkAlert
    }
    
        
        
    
    static let sharedInstance = UdacityClient()
    
}
