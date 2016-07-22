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
     Tries to create a guardian

     - parameter id:       unique identifier
     - parameter name:     guardian's name
     - parameter surname:  guardian's surname
     - parameter gender:   guardian's gender
     - parameter email:    guardian's email
     - parameter students: optional list of students

     - throws: error of CreationError.InvalidEmail type

     - returns: struct VO of Guardian type
     */
    static func createGuardian(id: Int, name: String, surname: String, gender: Gender, email: String, students: [Student]?) throws -> Guardian {

        if !StringsValidation.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        return Guardian(profileID: id, name: name, surname: surname, gender: gender, email: email, students: nil)
    }
}
