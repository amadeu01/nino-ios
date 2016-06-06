//
//  LoginService.swift
//  Nino
//
//  Created by Danilo Becke on 25/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class LoginMechanism: NSObject {

    /**
     Tries to generate a credential
     
     - parameter key: key with login information
     
     - returns: tuple containing (accessToken: String, error: Int)
     */
    static func login(key: Key) -> (accessToken: String?, error: Int?) {
        return ("ok", nil)
    }
}
