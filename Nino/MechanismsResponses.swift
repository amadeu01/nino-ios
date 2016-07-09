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
 Model of request responses
 
 - parameter json:      JSON with response
 - parameter error:     optional error
 */
typealias ServiceResponse = (json: JSON, error: NSError?, statusCode: Int?) -> Void
