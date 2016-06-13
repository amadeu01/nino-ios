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
        completionHandler(accessToken: "ok", error: nil)
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
        completionHandler(userID: 123, error: nil, data: nil)
    }
}
