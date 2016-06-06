//
//  CreationError.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 Class designed to manage errors related to creation of VOs

 - TargetNotFound:   Missing parameters (at least one target should be non nil)
 - ContentNotFound:  Missing parameters (message or attachment should be non nil)
 - InvalidBirthDate: Invalid birthdate
 - InvalidEmail:     Invalid format
 */
enum CreationError: ErrorType {
    case TargetNotFound
    case ContentNotFound
    case InvalidBirthDate
    case InvalidEmail
}
