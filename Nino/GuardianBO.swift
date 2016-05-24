//
//  GuardianBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all guardian's services
class GuardianBO: NSObject {

    /**
     Try to create a guardian

     - parameter id:       unique identifier
     - parameter name:     guardian's name
     - parameter surname:  guardian's surname
     - parameter email:    guardian's email
     - parameter students: optional list of students

     - throws: error of CreationError.InvalidEmail type

     - returns: struct VO of Guardian type
     */
    func createGuardian(id: Int, name: String, surname: String, email: String, students: [Student]?) throws -> Guardian {

        if !StringsValidation().isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        return Guardian(id: id, name: name, surname: surname, email: email, students: students)
    }
}
