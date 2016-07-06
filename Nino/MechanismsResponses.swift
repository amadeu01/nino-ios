//
//  MechanismsResponses.swift
//  Nino
//
//  Created by Danilo Becke on 11/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 Model of server responses
 
 - parameter userID:    optional userID
 - parameter error:     optional error
 - parameter data:      optional extra information about the error
 */
typealias ServerResponse = (userID: Int?, error: Int?, data: String?) -> Void

/**
 Model of request responses
 
 - parameter json:      JSON with response
 - parameter error:     optional error
 */
typealias ServiceResponse = (json: JSON, error: NSError?) -> Void