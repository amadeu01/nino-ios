//
//  Credential.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one Credential
 */
struct Credential {

//MARK: Attributes
    let token: String

//MARK: Initializer
    /**
     Initialize one credential

     - parameter token: user token for the current session

     - returns: struct VO of Credential type
     */
    init(token: String) {
        self.token = token
    }
}
