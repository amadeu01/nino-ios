//
//  NinoSession.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 5/29/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class NinoSession {
    /**
     Saves the login and password for the current session.
     
     - parameter username: the uername to be saved
     - parameter password: the password to be saved
     */
    class func saveLoginAndPasswordForSession(username: String, password: String) {
    KeychainWrapper.setString(password, forKey: "password")
    NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")

    }
    /**
     Returns the current username that is saved. If none, returns nil.
     
     - returns: username saved in User Defaults
     */
    class func getUsername() -> String? {
        
        return NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
    }
    /**
     Gets the password saved in the Keychain.
     
     - returns: password saved in Keychain
     */
    class func getPassword() -> String? {
        return KeychainWrapper.stringForKey("password")
    }
    /**
     Removes the password and username saved in the system, if there's any.
     */
    class func removePasswordAndUsername() {
        KeychainWrapper.removeObjectForKey("password")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
    }
    
    
}
