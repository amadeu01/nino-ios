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

    private static let baseURL: String = {
        guard let plist = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") else {
            NinoSession.sharedInstance.kamikaze(["error":"CRITICAL - Could not read URL from Info.plist", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            return "localhost/"
        }
        if let dict = NSDictionary(contentsOfFile: plist) {
            guard let url = dict.valueForKey("URL") as? String else {
                NinoSession.sharedInstance.kamikaze(["error":"CRITICAL - Could not read URL from Info.plist", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                return "localhost/"
            }
            return url
        } else {
            NinoSession.sharedInstance.kamikaze(["error":"CRITICAL - Could not read URL from Info.plist", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            return "localhost/"
        }
    }()
    
    private static let device: String = {
        let webView = UIWebView(frame: CGRectZero)
        let string = webView.stringByEvaluatingJavaScriptFromString("navigator.userAgent")
        return string!
    }()
    
    /**
     Makes GET request to api.ninoapp.com.br/
     
     - parameter group:        optional int to make requests in group
     - parameter path:         path to make the request
     - parameter token:        optional user token
     - parameter onCompletion: Completion block with JSON data and NSError
     */
    static func makeHTTPGetRequest(group: Int?, path: String, token: String?, onCompletion: ServiceResponse) {
        let url = baseURL + path
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.setValue(self.device, forHTTPHeaderField: "User-Agent")
        if let userToken = token {
            request.setValue(userToken, forHTTPHeaderField: "x-access-token")
        }
        let session = NSURLSession.sharedSession()
        if let ninoGroup = group {
            dispatch_group_enter(NinoDispatchGroupes.getGroup(ninoGroup))
        }
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
            if let ninoGroup = group {
                dispatch_group_leave(NinoDispatchGroupes.getGroup(ninoGroup))
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
            request.setValue(self.device, forHTTPHeaderField: "User-Agent")
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
    
    static func makeHTTPPutRequest(path: String, body: [String : AnyObject], onCompletion: ServiceResponse) {
        let url = baseURL + path
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "PUT"
        do {
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = jsonBody
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue(self.device, forHTTPHeaderField: "User-Agent")
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
    
    static func makeHTTPDeleteRequest(path: String, body: [String : AnyObject], onCompletion: ServiceResponse) {
        let url = baseURL + path
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "DELETE"
        do {
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = jsonBody
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue(self.device, forHTTPHeaderField: "User-Agent")
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
    
    static func makeHTTPPostUploadRequest(path: String, token: String, data: NSData, onCompletion: ServiceResponse) {
        let url = baseURL + path
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "PUT"
        let boundary = self.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "x-access-token")
        request.setValue(self.device, forHTTPHeaderField: "User-Agent")
        
        let body = NSMutableData()
        let fname = "image.png"
        let mimetype = "image/png"
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"picture\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(data)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
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
        }
        task.resume()
    }
    
    private static func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
}
