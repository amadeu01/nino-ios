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
     - parameter telephone:         school's phone
     - parameter email:             school's main email
     - parameter logo:              optional school's logo
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns a School
     
     - throws: error of CreationError.InvalidEmail type
     */
    static func createSchool(token: String, name: String, address: String, telephone: String, email: String, logo: NSData?, completionHandler: (getSchool: () throws -> School) -> Void) throws {

        if !StringsValidation.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        //tries to create a school
        SchoolMechanism.createSchool(token, name: name, address: address, telephone: telephone, email: email, logo: logo) { (schoolID, error, data) in
            if let errorType = error {
                //TODO: handle error data
                completionHandler(getSchool: { () -> School in
                    throw ErrorBO.decodeServerError(errorType)
                })
            }
            //success
            else if let school = schoolID {
                //has profile image
                if let imageData = logo {
                    //tries to send the profile image
                    SchoolMechanism.sendProfileImage(token, imageData: imageData, schoolID: school, completionHandler: { (success, error, data) in
                        if let err = error {
                            completionHandler(getSchool: { () -> School in
                                throw ErrorBO.decodeServerError(err)
                            })
                        }
                        //success
                        else if let success = success {
                            if success {
                                completionHandler(getSchool: { () -> School in
                                    return School(schoolId: school, name: name, address: address, legalNumber: nil, telephone: telephone, email: email, owner: nil, logo: logo)
                                })
                            }
                        } else {
                            completionHandler(getSchool: { () -> School in
                                throw ServerError.UnexpectedCase
                            })
                        }
                    })
                }
                //without profile image
                else {
                    completionHandler(getSchool: { () -> School in
                        return School(schoolId: school, name: name, address: address, legalNumber: nil, telephone: telephone, email: email, owner: nil, logo: nil)
                    })
                }
            }
            //unexpected case
            else {
                completionHandler(getSchool: { () -> School in
                    throw ServerError.UnexpectedCase
                })
            }
        }
    }
    
    static func getSchool(token: String, schoolServerID: Int, completionHandler: (school: () throws -> School) -> Void) {
        SchoolMechanism.getSchool(token, schoolID: schoolServerID) { (name, email, telephone, address, error, data) in
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
                return School(schoolId: schoolServerID, name: schoolName, address: schoolAddr, legalNumber: nil, telephone: schoolPhone, email: schoolEmail, owner: nil, logo: nil)
            })
        }
    }
    
    static func getIdForSchool(school: String) throws -> Int {
        //TODO: call DAO and look for schoolID
        return 2
    }
}
