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
//    static func createEducator(name: String, surname: String, gender: Gender, email: String, school: [School]?, phases: [Phase]?, rooms: [Room]?, completionHandler: (getEducator: () throws -> Educator) -> Void) throws {
//
//        if !StringsValidation.isValidEmail(email) {
//            throw CreationError.InvalidEmail
//        }
//
//    }
    
    static func getEducator(email: String, token: String, completionHandler: (getProfileAndSchoolID: () throws -> (Educator, Int)) -> Void) {
        
        var userName: String?
        var userSurname: String?
        var userBirthDate: NSDate?
        var userGender: Int?
        var profileError: Int?
        var profileData: String?
        var userID: Int?
        var userSchools: [Int]?
        var employeeError: Int?
        var employeeData: String?
        
        AccountMechanism.getMyProfile(0, token: token) { (profileID, name, surname, birthDate, gender, error, data) in
            userName = name
            userSurname = surname
            userBirthDate = birthDate
            userGender = gender
            profileError = error
            profileData = data
            userID = profileID
        }
        
        AccountMechanism.getEmployeeInformation(0, token: token) { (schools, error, data) in
            userSchools = schools
            employeeError = error
            employeeData = data
        }
        
        dispatch_group_notify(NinoDispatchGroupes.getGroup(0), dispatch_get_main_queue()) {
            //error
            //TODO: handle error data in both cases
            if let error = profileError {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ErrorBO.decodeServerError(error)
                })
            }
            if let error = employeeError {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ErrorBO.decodeServerError(error)
                })
            }
            //unexpected cases
            guard let name = userName else {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let surname = userSurname else {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let genderInt = userGender else {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let gender = Gender(rawValue: genderInt) else {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let profID = userID else {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            guard let schoolID = userSchools where schoolID.count > 0 else {
                completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                    throw ServerError.UnexpectedCase
                })
                return
            }
            //success
            completionHandler(getProfileAndSchoolID: { () -> (Educator, Int) in
                //FIXME: retrieve the correct school
                return (Educator(id: StringsMechanisms.generateID(), profileID: profID, name: name, surname: surname, gender: gender, email: email, rooms: nil), schoolID.first!)
            })
        }
        
    }
}
