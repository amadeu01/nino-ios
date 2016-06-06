//
//  CredentialBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of credential
class CredentialBO: NSObject {

    /**
     Try to create a credential

     - parameter token: user token for the current session

     - returns: struct VO of Credential type
     */
    static func createCredential(token: String) -> Credential {
        return Credential(token: token)
    }
}
