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

     - parameter key: Key VO

     - throws: ServerError type

     - returns: Credential VO
     */
    static func login(key: Key) throws -> Credential {
        let (str, nmb) = LoginMechanism.login(key)

        if let error = nmb {
            throw ErrorBO.decodeServerError(error)
        } else if let token = str {
            let credential = CredentialBO.createCredential(token)
            return credential
        }
        throw ServerError.Timeout
    }
}
