//
//  WebViewController.swift
//  OnTheMap
//
//  Created by CarlJohan on 31/03/17.
//  Copyright © 2017 Carl-Johan. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var WebView: UIWebView!
    var urlRequest: URLRequest? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let urlRequest = urlRequest {
            WebView.loadRequest(urlRequest)
        }
        
    }
 
    func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
