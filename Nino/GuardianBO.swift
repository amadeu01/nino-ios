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
                                                dispatch_async(dispatch_get_main_queue(), { 
                                                    completionHandler(guardian: { () -> Guardian in
                                                        return Guardian(id: guardian.id, profileID: guardianID, name: guardian.name, surname: guardian.surname, gender: guardian.gender, email: guardian.email, students: guardian.students)
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
    
    static func getGuardiansForStudent(student: String, completionHandler: (getGuardians: () throws -> [Guardian]) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(getGuardians: { () -> [Guardian] in
                    throw AccountError.InvalidToken
                })
            })
            return
        }
        StudentBO.getIdForStudent(student) { (id) in
            do {
                let id = try id()
                GuardianDAO.sharedInstance.getGuardiansForStudent(student, completionHandler: { (guardians) in
                    do {
                        let localGuardians = try guardians()
                        dispatch_async(dispatch_get_main_queue(), { 
                            completionHandler(getGuardians: { () -> [Guardian] in
                                return localGuardians
                            })
                        })
                        GuardianMechanism.getGuardians(token, studentID: id, completionHandler: { (info, error, data) in
                            if let errorType = error {
                                //TODO: Handle error data and code
                                let error = NotificationMessage()
                                error.setServerError(ErrorBO.decodeServerError(errorType))
                                dispatch_async(dispatch_get_main_queue(), {
                                    NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: error, info: nil)
                                })
                            } else if let guardiansInfo = info {
                                var serverGuardians = [Guardian]()
                                for dict in guardiansInfo {
                                    let guardianID = dict["id"] as? Int
                                    let guardianName = dict["name"] as? String
                                    let guardianSurname = dict["surname"] as? String
                                    let guardianEmail = dict["email"] as? String
                                    let guardianGender = dict["gender"] as? Int
                                    let guardianBirthdate = dict["birthdate"] as? NSDate
                                    guard let id = guardianID else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    guard let name = guardianName else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    guard let surname = guardianSurname else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    guard let email = guardianEmail else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    var gender: Gender?
                                    if let genderInt = guardianGender {
                                        gender = Gender(rawValue: genderInt)
                                    }
                                    let guardian = Guardian(id: StringsMechanisms.generateID(), profileID: id, name: name, surname: surname, gender: gender, email: email, students: [student])
                                    serverGuardians.append(guardian)
                                }
                                let comparison = self.compareGuardians(serverGuardians, localGuardians: localGuardians)
                                let wasChanged = comparison["wasChanged"]
                                let wasDeleted = comparison["wasDeleted"]
                                let newGuardians = comparison["newGuardians"]
                                if newGuardians!.count > 0 {
                                    GuardianDAO.sharedInstance.createGuardians(newGuardians!, completionHandler: { (write) in
                                        do {
                                            try write()
                                            let message = NotificationMessage()
                                            message.setDataToInsert(newGuardians!)
                                            dispatch_async(dispatch_get_main_queue(), {
                                                NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: nil, info: message)
                                            })
                                        } catch {
                                            //TODO: handle Realm error
                                        }
                                    })
                                }
                                //TODO: guardian was deleted
                                //TODO: guardian was updated
                            } else {
                                let error = NotificationMessage()
                                error.setServerError(ServerError.UnexpectedCase)
                                dispatch_async(dispatch_get_main_queue(), {
                                    NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: error, info: nil)
                                })
                            }
                        })
                    } catch let error {
                        //TODO: handle realm error
                    }
                })
            } catch {
                //TODO: handle missing id error
            }
        }
    }
    
    private static func compareGuardians(serverGuardians: [Guardian], localGuardians: [Guardian]) -> [String: [Guardian]] {
        var result = [String: [Guardian]]()
        var wasChanged = [Guardian]()
        var newGuardians = [Guardian]()
        var wasDeleted = [Guardian]()
        //check all server guardians
        for serverGuardian in serverGuardians {
            var found = false
            //look for its similar
            for localGuardian in localGuardians {
                //found
                if serverGuardian.profileID == localGuardian.profileID {
                    found = true
                    //updated
                    if serverGuardian.name != localGuardian.name {
                        wasChanged.append(serverGuardian)
                    } else {
                        if serverGuardian.surname != localGuardian.surname {
                            wasChanged.append(serverGuardian)
                        } else {
                            if serverGuardian.email != localGuardian.email {
                                wasChanged.append(serverGuardian)
                            } else {
                                if serverGuardian.gender != localGuardian.gender {
                                    wasChanged.append(serverGuardian)
                                }
                            }
                        }
                    }
                    break
                }
            }
            //not found locally
            if !found {
                newGuardians.append(serverGuardian)
            }
        }
        for localGuardian in localGuardians {
            var found = false
            for serverGuardian in serverGuardians {
                if localGuardian.profileID == serverGuardian.profileID {
                    found = true
                    break
                }
            }
            if !found {
                wasDeleted.append(localGuardian)
            }
        }
        
        result["newGuardians"] = newGuardians
        result["wasChanged"] = wasChanged
        result["wasDeleted"] = wasDeleted
        return result
    }
    
}
