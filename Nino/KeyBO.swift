//
//  KeyBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

/// Class which manages all sevices of keys
class KeyBO: NSObject {

    /**
     Creater a session key
     
     - parameter email:    user's email
     - parameter password: user's password
     
     - returns: Key VO
     */
    func createKey(email: String, password: String) -> Key {
        self.saveUsernameAndPassword(email, password: password)
        return Key(email: email, password: password)
    }
    
    /**
     Saves the username and password for the current session.
     
     - parameter username: the uername to be saved
     - parameter password: the password to be saved
     */
    private func saveUsernameAndPassword(username: String, password: String) {
        KeychainWrapper.setString(password, forKey: "password")
        NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
    }
    
    /**
     Returns the current username that is saved. If none, returns nil.
     
     - returns: username saved in User Defaults
     */
    static func getUsername() -> String? {
        return NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
    }
    
    /**
     Gets the password saved in the Keychain.
     
     - returns: password saved in Keychain
     */
    static func getPassword() -> String? {
        return KeychainWrapper.stringForKey("password")
    }
    
    /**
     Removes the password and username saved in the system, if there's any.
     */
    static func removePasswordAndUsername() {
        KeychainWrapper.removeObjectForKey("password")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
    }
}
