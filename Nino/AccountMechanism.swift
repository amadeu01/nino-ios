//
//  LoginMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 25/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

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
    static func createAccount(name: String, surname: String, gender: Gender, email: String, completionHandler: ServerResponse) {
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) { 
            completionHandler(userID: 123, error: nil, data: nil)
        }
    }
}
