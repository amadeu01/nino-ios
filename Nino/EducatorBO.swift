//
//  EducatorBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all educator's services
class EducatorBO: NSObject {

    /**
     Try to create a student

     - parameter id:      unique identifier
     - parameter name:    educator's name
     - parameter surname: educator's surname
     - parameter email:   educator's email
     - parameter school:  optional list of schools
     - parameter phases:  optional list of phases
     - parameter rooms:   optional list of rooms

     - throws: error of CreationError.InvalidEmail type

     - returns: struct VO of Guardian type
     */
    static func createEducator(id: Int, name: String, surname: String, email: String, school: [School]?, phases: [Phase]?, rooms: [Room]?) throws -> Educator {

        if !StringsValidation.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        return Educator(id: id, name: name, surname: surname, email: email, school: school, phases: phases, rooms: rooms)
    }
}
