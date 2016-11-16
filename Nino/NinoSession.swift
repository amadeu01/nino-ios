//
//  NinoSession.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 5/29/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import Mixpanel
import JWTDecode

class NinoSession: NSObject {
    
    static let sharedInstance = NinoSession()
    private var _credential: Credential?
    private var _educator: String?
    private var _school: String?
    /// User credential, get only
    
    func getCredential(completionHandler: (getCredential: () throws -> Credential) -> Void) -> Void {
        let renewToken = {
            guard let email = KeyBO.getUsername() else {
                completionHandler(getCredential: { () -> Credential in
                    throw AccountError.UserCredentialsNotSaved
                })
                return
            }
            guard let password = KeyBO.getPassword() else {
                completionHandler(getCredential: { () -> Credential in
                    throw AccountError.UserCredentialsNotSaved
                })
                return
            }
            let key = Key(email: email, password: password)
            LoginBO.login(key, completionHandler: { (getCredential) in
                do {
                    let cred = try getCredential()
                    self._credential = cred
                    completionHandler(getCredential: { () -> Credential in
                        return cred
                    })
                } catch let error{
                    completionHandler(getCredential: { () -> Credential in
                        throw error
                    })
                }
            })
        }

        do {
            guard let credential = _credential else {
                renewToken()
                return
            }
            let jwt = try decode(credential.token)
            let expiration = jwt.body["exp"] as? Int
            if (expiration != nil && Double(expiration!) < NSDate().timeIntervalSince1970) {
                renewToken()
            } else {
                completionHandler(getCredential: { () -> Credential in
                    return credential
                })
            }
        } catch {
            renewToken()
        }
    }
    
    /// Active educator, get only
    var educatorID: String? {
        return _educator
    }
    /// Active school, get only
    var schoolID: String? {
        return _school
    }
    
    private override init () {
        super.init()
    }
    
    /**
     Set user credential
     
     - parameter credential: new credential
     */
    func setCredential(credential: Credential) {
        self._credential = credential
    }
    
    /**
     Set active educator
     
     - parameter educator: active educator
     */
    func setEducator(educator: String) {
        self._educator = educator
    }
    
    /**
     Set active school
     
     - parameter school: active school
     */
    func setSchool(school: String) {
        self._school = school
    }
    
    func resetSession() {
        self._credential = nil
        self._educator = nil
        self._school = nil
    }
    
    
    /**
     This function is used to log unhandled error and kill graciously the application, logging what error occurred in order to make it possible to fix it in future versions
     It is called in unhandled errors
     
     - parameter log: Description of the error
     */
    func kamikaze(log: [String: AnyObject]) {
        print(log)
        Mixpanel.mainInstance().track(event: "Kamikazed", properties: log)
        LoginBO.logout { (out) in
            do {
                try out()
                let a: Int? = nil
                print(a!)
            } catch let error {
                let a: Int? = nil
                print(a!)
            }
        }
    }
    
}
