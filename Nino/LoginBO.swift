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

//    static func login(key: Key) throws -> Credential {
//        var error: ServerError?
//        var credential: Credential?
//        LoginMechanism.login(key) { (accessToken, nmb) in
//            if let errorType = nmb {
//                error = ErrorBO.decodeServerError(errorType)
//            } else if let token = accessToken {
//                credential = CredentialBO.createCredential(token)
//            }
//        }
//        if let err = error {
//            throw err
//        } else if let cred = credential {
//            return cred
//        }
//    }
    
    /**
     Tries to login
     
     - parameter key:               Key VO with user information
     - parameter completionHandler: completionHandler with optional Credential and optional Server Error
     */
    static func login(key: Key, completionHandler: (credential:Credential?, error:ServerError?) -> Void) {
        LoginMechanism.login(key) { (accessToken, error) in
            if let errorType = error {
                completionHandler(credential: nil, error: ErrorBO.decodeServerError(errorType))
            } else if let token = accessToken {
                completionHandler(credential: CredentialBO.createCredential(token), error: nil)
            }
            completionHandler(credential: nil, error: ServerError.Timeout)
        }
    }
    
    
}
