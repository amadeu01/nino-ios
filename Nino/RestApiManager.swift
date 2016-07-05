//
//  RestApiManager.swift
//  Nino
//
//  Created by Danilo Becke on 05/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestApiManager: NSObject {

    private static let baseURL = "api.ninoapp.com.br/"
    
    static func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if let jsonData = data {
                let json = JSON(data: jsonData)
                onCompletion(json: json, error: error)
            } else {
                onCompletion(json: nil, error: error)
            }
        }
        task.resume()
    }
    
    
}
