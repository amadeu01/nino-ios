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
}
