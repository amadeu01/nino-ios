//
//  ServerResponse.swift
//  Nino
//
//  Created by Danilo Becke on 11/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 Model of server responses
 
 - parameter userID:    optional userID
 - parameter error:     optional error
 - parameter data:      optional extra information about the error
 */
typealias ServerResponse = (userID: Int?, error: Int?, data: String?) -> Void