//
//  AccountBO.swift
//  Nino
//
//  Created by Danilo Becke on 07/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class AccountBO: NSObject {
    
    /**
     Creates a new account
     
     - parameter name:              user name
     - parameter surname:           user surname
     - parameter gender:            user gender
     - parameter email:             user email
     - parameter completionHandler: completion handler with a function that can throw a Server or a Creation error or return a profileID
     
     - throws:  CreationError.InvalidEmail
     */
    static func createAccount(name: String, surname: String, gender: Gender, email: String, completionHandler: (getAccount: () throws -> Int) -> Void) throws {

        if !StringsMechanisms.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        
        AccountMechanism.createAccount(name, surname: surname, gender: gender.rawValue, email: email) { (profileID, error, data) in
            if let errorType = error {
                //TODO: Handle error data and code
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getAccount: { () -> Int in
                        throw ErrorBO.decodeServerError(errorType)
                    })
                })
            } else if let user = profileID {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getAccount: { () -> Int in
                        return user
                    })
                })
            }
                //unexpected case
            else {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getAccount: { () -> Int in
                        throw ServerError.UnexpectedCase
                    })
                })
            }
        }
    }
    
    
    static func enableNotifications(deviceToken: String, completionHandler: (getStatus: () throws -> Void) -> Void) {
        NinoSession.sharedInstance.getCredential({ (getCredential) in
            do {
                let token = try getCredential().token
                AccountMechanism.enableNotifications(token, deviceToken: deviceToken) { (error, data) in
                    if let errorType = error {
                        //TODO: Handle error data and code
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(getStatus: { () -> Void in
                                throw ErrorBO.decodeServerError(errorType)
                            })
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(getStatus: { () -> Void in
                                return
                            })
                        })
                    }
                }
            } catch let error {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(getStatus: { () -> Void in
                        throw AccountError.InvalidToken
                    })
                })
            }
        })
    }
    
    /**
     Checks if the user hash is valid
     
     - parameter hash:              user hash
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns a boolean indicating if the hash is valid
     */
    static func checkIfValidated(hash: String, completionHandler: (checkHash: () throws -> Bool) -> Void) {
        AccountMechanism.checkIfValidated(hash) { (validated, error, data) in
            //TODO: Handle error data
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(checkHash: { () -> Bool in
                        throw ErrorBO.decodeServerError(error)
                    })
                })
            }
            //Unexpected case
            guard let validated = validated else {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(checkHash: { () -> Bool in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            //success
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(checkHash: { () -> Bool in
                    //returns true if is valid
                    return !validated
                })
            })
        }
    }
    
    /**
     Confirms the user account
     
     - parameter hash:              user hash
     - parameter password:          user password
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns a boolean indicating that the account was confirmed.
     */
    static func registerPassword(hash: String, password: String, completionHandler: (register: () throws -> String) -> Void) {
        AccountMechanism.confirmAccount(password, hash: hash) { (token, error, data) in
            //TODO: handle error data
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(register: { () -> String in
                        throw ErrorBO.decodeServerError(error)
                    })
                })
            }
            //Unexpected case
            guard let userToken = token else {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(register: { () -> String in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            //success
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(register: { () -> String in
                    return userToken
                })
            })
        }
    }
    
    
    static func changePassword(email: String, completionHandler: (change: () throws -> Void) -> Void) throws {
        if !StringsMechanisms.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        AccountMechanism.changePassword(email) { (success, error, data) in
            if let err = error {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(change: { 
                        throw ErrorBO.decodeServerError(err)
                    })
                })
            } else if let done = success {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(change: { 
                        return
                    })
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(change: { 
                        throw ServerError.UnexpectedCase
                    })
                })
            }
        }
        
    }
}
