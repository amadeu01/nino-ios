//
//  LoginMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 25/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import SwiftyJSON

/// Mechanism designed to handle all account operations
class AccountMechanism: NSObject {

    /**
     Tries to generate a credential
     
     - parameter key:                key with login information
     - parameter completionHandler:  completionHandler with optional accessToken and optional error
     */
    static func login(key: Key, completionHandler: (accessToken: String?, error: Int?) -> Void) {
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completionHandler(accessToken: "fdsf", error: nil)
        }
    }
    
    /**
     Tries to create an account
     
     - parameter name:              person name
     - parameter surname:           person surname
     - parameter gender:            person gender
     - parameter key:               key with login information
     - parameter completionHandler: completionHandler with optional userID, optional error and optional extra information about the error
     */
    static func createAccount(name: String, surname: String, gender: Gender, email: String, completionHandler: (userID: Int?, error: Int?, data: String?) -> Void) {
        
        let body: [String: AnyObject] = ["name": name, "surname": surname, "email": email, "gender": gender.hashValue]
        do {
            let route = try ServerRoutes.CreateUser.description(nil)
            RestApiManager.makeHTTPPostRequest(route, body: body) { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    //TODO: handle nil status code
                    completionHandler(userID: nil, error: nil, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(userID: nil, error: error, data: data)
                }
                //success
                else {
                    let userID = json["profile"]["id"].int
                    completionHandler(userID: userID, error: nil, data: nil)
                }
            }
        }
        //path error - in this case, never will be reached
        catch {
            
        }
    }
    
    static func checkIfValidated(hash: String, completionHandler: (validated: Bool?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CheckIfValidated.description([hash])
            RestApiManager.makeHTTPGetRequest(route, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    //TODO: handle nil status code
                    completionHandler(validated: nil, error: nil, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(validated: nil, error: error, data: data)
                }
                //success
                else {
                    let validated = json["account"]["validated"].bool
                    completionHandler(validated: validated, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: Handle missing parameter error
        }
    }
    
    static func confirmAccount(password: String, hash: String, completionHandler: (done: Bool?, error: Int?, data: String?) -> Void) {
        let body: [String: AnyObject] = ["password": password]
        do {
            let route = try ServerRoutes.ConfirmAccount.description([hash])
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    //TODO: handle nil status code
                    completionHandler(done: nil, error: nil, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(done: nil, error: error, data: data)
                }
                //success
                else {
                    completionHandler(done: true, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
}
