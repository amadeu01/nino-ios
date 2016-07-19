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
                if let imageData = logo {
                    SchoolMechanism.sendProfileImage(token, imageData: imageData, schoolID: school, completionHandler: { (success, error, data) in
                        if let err = error {
                            completionHandler(getSchool: { () -> School in
                                throw ErrorBO.decodeServerError(err)
                            })
                        } else if let success = success {
                            if success {
                                completionHandler(getSchool: { () -> School in
                                    var phasesArray: [Phase]?
                                    if let phs = phases {
                                        phasesArray = phs
                                    } else {
                                        phasesArray = [Phase]()
                                    }
                                    return School(id: school, name: name, address: address, cnpj: cnpj, telephone: telephone, email: email, owner: owner, logo: logo, phases: phasesArray, educators: educators, students: students, menus: menus, activities: activities, calendars: calendars)
                                })
                            }
                        } else {
                            completionHandler(getSchool: { () -> School in
                                throw ServerError.UnexpectedCase
                            })
                        }
                    })
                }
            } else {
                completionHandler(getSchool: { () -> School in
                    throw ServerError.UnexpectedCase
                })
            }
        }
    }
    
    static func getSchool(token: String, schoolID: Int, completionHandler: (school: () throws -> School) -> Void) {
        SchoolMechanism.getSchool(token, schoolID: schoolID) { (name, email, telephone, address, error, data) in
            //TODO: handle error data
            if let error = error {
                completionHandler(school: { () -> School in
                    throw ErrorBO.decodeServerError(error)
                })
            }
            //Unexpected cases
            guard let schoolName = name else {
                completionHandler(school: { () -> School in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let schoolEmail = email else {
                completionHandler(school: { () -> School in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let schoolPhone = telephone else {
                completionHandler(school: { () -> School in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let schoolAddr = address else {
                completionHandler(school: { () -> School in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            //success
            completionHandler(school: { () -> School in
                return School(id: schoolID, name: schoolName, address: schoolAddr, cnpj: nil, telephone: schoolPhone, email: schoolEmail, owner: nil, logo: nil, phases: nil, educators: nil, students: nil, menus: nil, activities: nil, calendars: nil)
            })
        }
    }
}
