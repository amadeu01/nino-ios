//
//  Key.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one key
 */
struct Key {

//MARK: Attributes
    let email: String
    let password: String

//MARK: Initializer
    /**
     Initialize one key

     - parameter email:    user's email
     - parameter password: user's password

     - returns: struct VO of Key type
     */
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
