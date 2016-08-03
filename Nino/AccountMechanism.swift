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
     
     - parameter email:              user email
     - parameter password:           user password
     - parameter completionHandler:  completionHandler with optional accessToken and optional error
     */
    static func login(email: String, password: String, completionHandler: (accessToken: String?, error: Int?) -> Void) {
        let passwordMD5 = MD5.digest(password)
        guard let passwd = passwordMD5 else {
            completionHandler(accessToken: nil, error: nil)
            return
        }
        let body: [String: AnyObject] = ["user": email, "password": passwd]
        do {
            let route = try ServerRoutes.Login.description(nil)
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(accessToken: nil, error: error?.code)
                    return
                }
                //error
                if statusCode != 200 {
                    let error = json["error"].int
                    completionHandler(accessToken: nil, error: error)
                }
                    //success
                else {
                    let token = json["data"]["token"].string
                    completionHandler(accessToken: token, error: nil)
                }
            })
        } catch {
            //Never will be reached
        }
        
    }
    
    /**
     Tries to create an account
     
     - parameter name:              person name
     - parameter surname:           person surname
     - parameter gender:            person gender.rawValue
     - parameter email:             user eamil
     - parameter completionHandler: completionHandler with optional profileID, optional error and optional extra information about the error
     */
    static func createAccount(name: String, surname: String, gender: Int, email: String, completionHandler: (profileID: Int?, error: Int?, data: String?) -> Void) {
        
        let body: [String: AnyObject] = ["name": name, "surname": surname, "email": email, "gender": gender]
        do {
            let route = try ServerRoutes.CreateUser.description(nil)
            RestApiManager.makeHTTPPostRequest(route, body: body) { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(profileID: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: data is a json, needs to be interpreted
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(profileID: nil, error: error, data: data)
                    
                }
                //success
                else {
                    let userID = json["data"]["profile"]["id"].int
                    completionHandler(profileID: userID, error: nil, data: nil)
                }
            }
        } catch {
            //path error - in this case, never will be reached
        }
    }
    
    /**
     Checks if the hash still valid
     
     - parameter hash:              user hash
     - parameter completionHandler: completionHandler with optional validated - false, if the hash is valid; optional error and optional extra information about the error
     */
    static func checkIfValidated(hash: String, completionHandler: (validated: Bool?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CheckIfValidated.description([hash])
            RestApiManager.makeHTTPGetRequest(nil, path: route, token: nil, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(validated: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: data is a json, needs to be interpreted
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(validated: nil, error: error, data: data)
                }
                //success
                else {
                    let validated = json["data"]["account"]["confirmed"].bool
                    completionHandler(validated: validated, error: nil, data: nil)
                }
            })
        } catch {
            //FIXME: send an email to contato@ninoapp.com.br notifying the route error
        }
    }
    
    /**
     Register password for the account
     
     - parameter password:          new password
     - parameter hash:              user hash
     - parameter completionHandler: completion handler with optional access token, optional error and optional data about the error
     */
    static func confirmAccount(password: String, hash: String, completionHandler: (token: String?, error: Int?, data: String?) -> Void) {
        let passwordMD5 = MD5.digest(password)
        guard let passwd = passwordMD5 else {
            completionHandler(token: nil, error: nil, data: nil)
            return
        }
        let body: [String: AnyObject] = ["password": passwd]
        do {
            let route = try ServerRoutes.ConfirmAccount.description([hash])
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(token: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: data is a json, needs to be interpreted
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(token: nil, error: error, data: data)
                }
                //success
                else {
                    let token = json["data"]["token"].string
                    completionHandler(token: token, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
    
    
    /**
     Gets information about the user profile
     
     - parameter group:             optional group for parallel requests
     - parameter token:             access token
     - parameter completionHandler: completion handler with optional: profileID; name, surname, birthDate, gender.rawValue, error and error data
     */
    static func getMyProfile(group: Int?, token: String, completionHandler: (profileID: Int?, name: String?, surname: String?, birthDate: NSDate?, gender: Int?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetMyProfile.description(nil)
            RestApiManager.makeHTTPGetRequest(group, path: route, token: token, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(profileID: nil, name: nil, surname: nil, birthDate: nil, gender: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: data is a json, needs to be interpreted
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(profileID: nil, name: nil, surname: nil, birthDate: nil, gender: nil, error: error, data: data)
                }
                //success
                else {
                    let name = json["data"]["name"].string
                    let surname = json["data"]["surname"].string
                    //FIXME: check if is working
                    let birthdate = json["data"]["birthdate"].object as? NSDate
                    let genderInt = json["data"]["gender"].int
                    let profileID = json["data"]["id"].int
                    completionHandler(profileID: profileID, name: name, surname: surname, birthDate: birthdate, gender: genderInt, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
}
