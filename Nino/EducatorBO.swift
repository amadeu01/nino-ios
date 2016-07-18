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
     Tries to create an educator
     
     - parameter name:    educator's name
     - parameter surname: educator's surname
     - parameter gender:  educator's gender
     - parameter email:   educator's key
     - parameter school:  optional list of schools
     - parameter phases:  optional list of phases
     - parameter rooms:   optional list of rooms
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns an Educator
     
     - throws: error of CreationError.InvalidEmail type
     */
    static func createEducator(name: String, surname: String, gender: Gender, email: String, school: [School]?, phases: [Phase]?, rooms: [Room]?, completionHandler: (getEducator: () throws -> Educator) -> Void) throws {

        if !StringsValidation.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        
        AccountMechanism.createAccount(name, surname: surname, gender: gender, email: email) { (userID, error, data) in
            if let errorType = error {
                //TODO: Handle error data and code
                completionHandler(getEducator: { () -> Educator in
                    throw ErrorBO.decodeServerError(errorType)
                })
            } else if let user = userID {
                completionHandler(getEducator: { () -> Educator in
                    return Educator(id: user, name: name, surname: surname, gender: gender, email: email, school: school, phases: phases, rooms: rooms)
                })
            }
            //unexpected case
            else {
                completionHandler(getEducator: { () -> Educator in
                    throw ServerError.UnexpectedCase
                })
            }
        }
    }
    
    static func getEducator(email: String, token: String, completionHandler: (getProfile: () throws -> Educator) -> Void) {
        
        var userName: String?
        var userSurname: String?
        var userBirthDate: NSDate?
        var userGender: Gender?
        var profileError: Int?
        var profileData: String?
        var userIDs: [Int]?
        var userSchools: [Int]?
        var employeeError: Int?
        var employeeData: String?
        
        AccountMechanism.getMyProfile(0, token: token) { (name, surname, birthDate, gender, error, data) in
            userName = name
            userSurname = surname
            userBirthDate = birthDate
            userGender = gender
            profileError = error
            profileData = data
        }
        
        AccountMechanism.getEmployeeInformation(0, token: token) { (ids, schools, error, data) in
            userIDs = ids
            userSchools = schools
            employeeError = error
            employeeData = data
        }
        
        dispatch_group_notify(NinoDispatchGroupes.getGroup(0), dispatch_get_main_queue()) {
            //error
            //TODO: handle error data in both cases
            if let error = profileError {
                completionHandler(getProfile: { () -> Educator in
                    throw ErrorBO.decodeServerError(error)
                })
            }
            if let error = employeeError {
                completionHandler(getProfile: { () -> Educator in
                    throw ErrorBO.decodeServerError(error)
                })
            }
            //unexpected cases
            guard let name = userName else {
                completionHandler(getProfile: { () -> Educator in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let surname = userSurname else {
                completionHandler(getProfile: { () -> Educator in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let gender = userGender else {
                completionHandler(getProfile: { () -> Educator in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let userId = userIDs where userId.count > 0 else {
                completionHandler(getProfile: { () -> Educator in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let schoolID = userSchools where schoolID.count > 0 else {
                completionHandler(getProfile: { () -> Educator in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            //success
            completionHandler(getProfile: { () -> Educator in
                //FIXME: retrieve the correct id and school
                NSUserDefaults.standardUserDefaults().setValue(schoolID.first!, forKey: "schoolID")
                return Educator(id: userId.first!, name: name, surname: surname, gender: gender, email: email, school: nil, phases: nil, rooms: nil)
            })
        }
        
    }
}
