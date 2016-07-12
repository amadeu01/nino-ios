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

//    private static let baseURL = "api.ninoapp.com.br/"
    private static let baseURL = "https://www.ninoapp.com.br:5000/"
    
    /**
     Makes GET request to api.ninoapp.com.br/
     
     - parameter path:         path to make the request
     - parameter onCompletion: Completion block with JSON data and NSError
     */
    static func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let url = baseURL + path
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode else {
                onCompletion(json: nil, error: error, statusCode: nil)
                return
            }
            if let jsonData = data {
                let json = JSON(data: jsonData)
                onCompletion(json: json, error: error, statusCode: statusCode)
            } else {
                onCompletion(json: nil, error: error, statusCode: statusCode)
            }
        }
        task.resume()
    }
    
    /**
     Makes POST request to api.ninoapp.com.br/
     
     - parameter path:         path to make the request
     - parameter body:         Dictionary with the body
     - parameter onCompletion: Completion block with JSON data and NSError
     */
    static func makeHTTPPostRequest(path: String, body: [String : AnyObject], onCompletion: ServiceResponse) {
        let url = baseURL + path
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        do {
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = jsonBody
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode else {
                    onCompletion(json: nil, error: error, statusCode: nil)
                    return
                }
                guard let jsonData = data else {
                    onCompletion(json: nil, error: error, statusCode: statusCode)
                    return
                }
                let json = JSON(data: jsonData)
                onCompletion(json: json, error: nil, statusCode: statusCode)
            })
            task.resume()
        } catch {
            onCompletion(json: nil, error: nil, statusCode: nil)
        }
        
    }
    
}
