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
     
     - parameter token:             user token
     - parameter name:              school's name
     - parameter address:           school's address
     - parameter cnpj:              optional school's legal number
     - parameter telephone:         school's phone
     - parameter email:             school's main email
     - parameter owner:             optional id of the owner of the school
     - parameter logo:              optional school's logo
     - parameter phases:            optional list of phases
     - parameter educators:         optional list of educators
     - parameter students:          optional list of students
     - parameter menus:             optional list of menus
     - parameter activities:        optional list of activities
     - parameter calendars:         ptional list of calendars
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns a School
     
     - throws: error of CreationError.InvalidEmail type
     */
    static func createSchool(token: String, name: String, address: String, cnpj: Int?, telephone: String, email: String, owner: Int?, logo: NSData?, phases: [Phase]?, educators: [Educator]?, students: [Student]?, menus: [Menu]?, activities: [Activity]?, calendars: [Calendar]?, completionHandler: (getSchool: () throws -> School) -> Void) throws {

        if !StringsValidation.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        
        SchoolMechanism.createSchool(token, name: name, address: address, telephone: telephone, email: email, logo: logo) { (schoolID, error, data) in
            if let errorType = error {
                //TODO: handle error data
                completionHandler(getSchool: { () -> School in
                    throw ErrorBO.decodeServerError(errorType)
                })
            } else if let school = schoolID {
                completionHandler(getSchool: { () -> School in
                    return School(id: school, name: name, address: address, cnpj: cnpj, telephone: telephone, email: email, owner: owner, logo: logo, phases: phases, educators: educators, students: students, menus: menus, activities: activities, calendars: calendars)
                })
            } else {
                completionHandler(getSchool: { () -> School in
                    throw ServerError.UnexpectedCase
                })
            }
        }
        
    }
    
    
}
