//
//  SchoolBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of school
class SchoolBO: NSObject {

    /**
     Tries to create a school

     - parameter id:         unique identifier
     - parameter name:       school's name
     - parameter address:    school's address
     - parameter cnpj:       school's legal number
     - parameter telephone:  school's phone
     - parameter email:      school's main email
     - parameter owner:      id of the owner of the school
     - parameter logo:       optional school's logo
     - parameter phases:     optional list of phases
     - parameter educators:  optional list of educators
     - parameter students:   optional list of students
     - parameter menus:      optional list of menus
     - parameter activities: optional list of activities
     - parameter calendars:  optional list of calendars

     - throws: error of CreationError.InvalidEmail type

     - returns: struct VO of School type
     */
    static func createSchool(id: Int, name: String, address: String, cnpj: Int, telephone: Int, email: String, owner: Int, logo: NSData?, phases: [Phase]?, educators: [Educator]?, students: [Student]?, menus: [Menu]?, activities: [Activity]?, calendars: [Calendar]?) throws -> School {

        if !StringsValidation.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        return School(id: id, name: name, address: address, cnpj: cnpj, telephone: telephone, email: email, owner: owner, logo: logo, phases: phases, educators: educators, students: students, menus: menus, activities: activities, calendars: calendars)
    }
}
