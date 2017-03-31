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

    var sessionID: String? = nil
    var accountKey: Int? = nil
    
    
    
    func getSessionID( completionHandlerForSessionID: @escaping (_ succes: Bool, _ error: String? ) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"carljohan.beurling@gmail.com\", \"password\": \"joeercool2\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
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
            print("sessionID: \(self.sessionID!)")
        
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
