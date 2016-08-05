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

    static func createGuardian(name: String, surname: String, email: String, studentID: String, completionHandler: (guardian: () throws -> Guardian) -> Void) throws {
        
        if !StringsMechanisms.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        
        guard let token = NinoSession.sharedInstance.credential?.token else {
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(guardian: { () -> Guardian in
                    throw AccountError.InvalidToken
                })
            })
            return
        }
        
        var guardian = Guardian(id: StringsMechanisms.generateID(), profileID: nil, name: name, surname: surname, gender: nil, email: email, students: [studentID])
        
        SchoolBO.getIdForSchool { (id) in
            do {
                let school = try id()
                StudentBO.getIdForStudent(studentID, completionHandler: { (id) in
                    do {
                        let student = try id()
                        GuardianDAO.sharedInstance.createGuardians([guardian], completionHandler: { (write) in
                            do {
                                try write()
                                GuardianMechanism.createGuardian(token, schoolID: school, studentID: student, email: email, name: name, surname: surname, completionHandler: { (profileID, error, data) in
                                    if let err = error {
                                        //TODO: handle error data
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(guardian: { () -> Guardian in
                                                throw ErrorBO.decodeServerError(err)
                                            })
                                        })
                                    } else if let guardianID = profileID {
                                        GuardianDAO.sharedInstance.updateGuardianID(guardian.id, id: guardianID, completionHandler: { (update) in
                                            do {
                                                try update()
                                                guardian.profileID = guardianID
                                                dispatch_async(dispatch_get_main_queue(), { 
                                                    completionHandler(guardian: { () -> Guardian in
                                                        return guardian
                                                    })
                                                })
                                            } catch {
                                                //TODO: handle realm error
                                            }
                                        })
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(guardian: { () -> Guardian in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                    }
                                })
                            } catch {
                                //TODO: handle realm error
                            }
                        })
                    } catch {
                        //TODO: handle getStudentID error
                    }
                })
            } catch {
                //TODO: handle getSchoolID error
            }
        }
    }
    
}
