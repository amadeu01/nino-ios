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
    
    static func getEducator(email: String, schoolID: Int, token: String, completionHandler: (getProfile: () throws -> Educator) -> Void) {
        
        var userName: String?
        var userSurname: String?
        var userBirthDate: NSDate?
        var userGender: Int?
        var profileError: Int?
        var profileData: String?
        var userID: Int?
        
        AccountMechanism.getMyProfile(0, token: token) { (profileID, name, surname, birthDate, gender, error, data) in
            userName = name
            userSurname = surname
            userBirthDate = birthDate
            userGender = gender
            profileError = error
            profileData = data
            userID = profileID
        }

        
        dispatch_group_notify(NinoDispatchGroupes.getGroup(0), dispatch_get_main_queue()) {
            //error
            //TODO: handle error data in both cases
            if let error = profileError {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getProfile: { () -> Educator in
                        throw ErrorBO.decodeServerError(error)
                    })
                })
            }
            //unexpected cases
            guard let name = userName else {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getProfile: { () -> Educator in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            guard let surname = userSurname else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(getProfile: { () -> Educator in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            guard let genderInt = userGender else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(getProfile: { () -> Educator in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            guard let gender = Gender(rawValue: genderInt) else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(getProfile: { () -> Educator in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            guard let profID = userID else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(getProfile: { () -> Educator in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            //success
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(getProfile: { () -> Educator in
                    return Educator(id: StringsMechanisms.generateID(), profileID: profID, name: name, surname: surname, gender: gender, email: email, rooms: nil)
                })
            })
        }
        
    }
}
