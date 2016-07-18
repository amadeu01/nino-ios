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
        let passwordMD5 = MD5.digest(key.password)
        guard let passwd = passwordMD5 else {
            completionHandler(accessToken: nil, error: nil)
            return
        }
        let body: [String: AnyObject] = ["user": key.email, "password": passwd]
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
                    completionHandler(userID: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: data is a json, needs to be interpreted
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(userID: nil, error: error, data: data)
                    
                }
                //success
                else {
                    let userID = json["data"]["profile"]["id"].int
                    completionHandler(userID: userID, error: nil, data: nil)
                }
            }
        }
        catch {
            //path error - in this case, never will be reached
        }
    }
    
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
    
    static func getMyProfile(group: Int?, token: String, completionHandler: (name: String?, surname: String?, birthDate: NSDate?, gender: Gender?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetMyProfile.description(nil)
            RestApiManager.makeHTTPGetRequest(group, path: route, token: token, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(name: nil, surname: nil, birthDate: nil, gender: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: data is a json, needs to be interpreted
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(name: nil, surname: nil, birthDate: nil, gender: nil, error: error, data: data)
                }
                //success
                else {
                    let name = json["data"]["name"].string
                    let surname = json["data"]["surname"].string
                    //FIXME: check if is working
                    let birthdate = json["data"]["birthdate"].object as? NSDate
                    let genderInt = json["data"]["gender"].int
                    var gender: Gender?
                    if let genderInt = genderInt {
                        gender = Gender(rawValue: genderInt)
                    } else {
                        gender = nil
                    }
                    completionHandler(name: name, surname: surname, birthDate: birthdate, gender: gender, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
    
    static func getEmployeeInformation(group: Int?, token: String, completionHandler: (ids: [Int]?, schools: [Int]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetEmployeeInformation.description(nil)
            RestApiManager.makeHTTPGetRequest(group, path: route, token: token, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(ids: nil, schools: nil, error: error?.code, data: nil)
                    return
                }
                if statusCode != 200 {
                    //FIXME: data is a json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(ids: nil, schools: nil, error: error, data: data)
                }
                //success
                else {
                    let schools =  json["data"].array
                    //FIXME: get other schools
                    let firstSchool = schools?.first?["school"].int
                    let firstEducatorID = schools?.first?["id"].int
                    guard let schoolID = firstSchool else {
                        completionHandler(ids: nil, schools: nil, error: nil, data: nil)
                        return
                    }
                    guard let educatorID = firstEducatorID else{
                        completionHandler(ids: nil, schools: nil, error: nil, data: nil)
                        return
                    }
                    completionHandler(ids: [educatorID], schools: [schoolID], error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
}
