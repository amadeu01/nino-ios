//
//  LoginBO.swift
//  Nino
//
//  Created by Danilo Becke on 25/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of login
class LoginBO: NSObject {
    
    /**
     Tries to login
     
     - parameter key:               Key VO with user information
     - parameter completionHandler: completion handler with other inside. The completion handler from the inside can throw an error or return a credential.
     */
    static func login(key: Key, completionHandler: (getCredential: () throws -> Credential) -> Void) {
        AccountMechanism.login(key) { (accessToken, error) in
            if let errorType = error {
                completionHandler(getCredential: { () -> Credential in
                    throw ErrorBO.decodeServerError(errorType)
                })
            } else if let token = accessToken {
                completionHandler(getCredential: { () -> Credential in
                    return CredentialBO.createCredential(token)
                })
            } else {
                completionHandler(getCredential: { () -> Credential in
                    throw ServerError.UnexpectedCase
                })
            }
        }
    }
    
}
