//
//  LoginBO.swift
//  Nino
//
//  Created by Danilo Becke on 25/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import JWTDecode

/// Class which manages all services of login
class LoginBO: NSObject {
    
    /**
     Tries to login
     
     - parameter key:               Key VO with user information
     - parameter completionHandler: completion handler with other inside. The completion handler from the inside can throw an error or return a credential.
     */
    private static var timer: NSTimer?
    
    private class KeyWrapper {
        let key: Key
        
        init(key: Key) {
            self.key = key
        }
    }
    
    static func login(key: Key, completionHandler: (getCredential: () throws -> Credential) -> Void) {
        AccountMechanism.login(key.email, password: key.password) { (accessToken, error) in
            if let errorType = error {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getCredential: { () -> Credential in
                        throw ErrorBO.decodeServerError(errorType)
                    })
                })
            } else if let token = accessToken {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getCredential: { () -> Credential in
                        let jwt = try decode(token)
                        if let expiration = jwt.body["exp"] as? Int {
                            if let currentTimer = self.timer {
                                currentTimer.invalidate()
                            }
                            print(Double(expiration) - NSDate().timeIntervalSince1970 - 60)
                            self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(expiration) - NSDate().timeIntervalSince1970 - 60, target: self, selector: #selector(refreshToken), userInfo: KeyWrapper(key: key), repeats: false)
                        }
                        
                        return CredentialBO.createCredential(token)
                    })
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getCredential: { () -> Credential in
                        throw ServerError.UnexpectedCase
                    })
                })
            }
        }
    }
    
    @objc private static func refreshToken(timer: NSTimer) {
        guard let key = timer.userInfo as? KeyWrapper else {
            //TODO: Here we should probably logout
            return
        }
        self.login(key.key) { (getCredential) in
            do {
                //tries to get the credential
                let credential = try getCredential()
                NinoSession.sharedInstance.setCredential(credential)
            } catch let error {
                //TODO: logout too?
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    static func logout(completionHandler: (out: () throws -> Void) -> Void) {
        LoginDAO.logout { (out) in
            do {
                try out()
                NinoSession.sharedInstance.resetSession()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(out: { 
                        return
                    })
                })
            } catch let error {
                //could not create realm
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(out: { 
                        throw error
                    })
                })
            }
        }
    }
    
}
