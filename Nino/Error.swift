//
//  Error.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one error
 */
struct Error {

//MARK: Attributes
    let code: Int
    let description: String
    var data: NSData?

//MARK: Initializer
    /**
     Initialize one error

     - parameter code:        error's code
     - parameter description: error's description
     - parameter data:        optional data

     - returns: struct VO of Error type
     */
    init(code: Int, description: String, data: NSData?) {
        self.code = code
        self.description = description
        if let extraInfo = data {
            self.data = extraInfo
        }
    }
}
