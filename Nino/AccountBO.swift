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
     Checks if the user hash is valid
     
     - parameter hash:              user hash
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns a boolean indicating if the hash is valid
     */
    static func checkIfValidated(hash: String, completionHandler: (checkHash: () throws -> Bool) -> Void) {
        AccountMechanism.checkIfValidated(hash) { (validated, error, data) in
            //TODO: Handle error data
            if let error = error {
                completionHandler(checkHash: { () -> Bool in
                    throw ErrorBO.decodeServerError(error)
                })
            }
            //Unexpected case
            guard let validated = validated else {
                completionHandler(checkHash: { () -> Bool in
                    throw ServerError.Timeout
                })
                return
            }
            //success
            completionHandler(checkHash: { () -> Bool in
                //returns true if is valid
                return !validated
            })
        }
    }
    
    /**
     Confirms the user account
     
     - parameter hash:              user hash
     - parameter password:          user password
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns a boolean indicating that the account was confirmed.
     */
    static func registerPassword(hash: String, password: String, completionHandler: (register: () throws -> Bool) -> Void) {
        AccountMechanism.confirmAccount(password, hash: hash) { (done, error, data) in
            //TODO: handle error data
            if let error = error {
                completionHandler(register: { () -> Bool in
                    throw ErrorBO.decodeServerError(error)
                })
            }
            //Unexpected case
            guard let done = done else {
                completionHandler(register: { () -> Bool in
                    throw ServerError.Timeout
                })
                return
            }
            //success
            completionHandler(register: { () -> Bool in
                return done
            })
        }
    }
}
