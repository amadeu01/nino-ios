//
//  StatusCodeError.swift
//  Nino
//
//  Created by Danilo Becke on 14/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

enum StatusCodeError: ErrorType {
    case Timeout
    case BadRequest
    case Unauthorized
    case Forbidden
    case NotFound
    case ServerError
}
