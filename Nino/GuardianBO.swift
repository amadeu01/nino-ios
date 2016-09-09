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
        
        let guardian = Guardian(id: StringsMechanisms.generateID(), profileID: nil, name: name, surname: surname, gender: nil, email: email, students: [studentID])
        
        SchoolBO.getIdForSchool { (id) in
            do {
                let school = try id()
                StudentBO.getIdForStudent(studentID, completionHandler: { (id) in
                    do {
                        let student = try id()
                        GuardianDAO.createGuardians([guardian], completionHandler: { (write) in
                            do {
                                try write()
                                GuardianMechanism.createGuardian(token, schoolID: school, studentID: student, email: email, completionHandler: { (profileID, error, data) in
                                    if let err = error {
                                        //TODO: handle error data
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(guardian: { () -> Guardian in
                                                throw ErrorBO.decodeServerError(err)
                                            })
                                        })
                                    } else if let guardianID = profileID {
                                        GuardianDAO.updateGuardianID(guardian.id, id: guardianID, completionHandler: { (update) in
                                            do {
                                                try update()
                                                dispatch_async(dispatch_get_main_queue(), { 
                                                    completionHandler(guardian: { () -> Guardian in
                                                        return Guardian(id: guardian.id, profileID: guardianID, name: guardian.name, surname: guardian.surname, gender: guardian.gender, email: guardian.email, students: guardian.students)
                                                    })
                                                })
                                            } catch let error {
                                                //TODO: handle realm error
                                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
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
                            } catch let error {
                                //TODO: handle realm error
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                            }
                        })
                    } catch let error {
                        //TODO: handle getStudentID error
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                })
            } catch let error {
                //TODO: handle getSchoolID error
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
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
                GuardianDAO.getGuardiansForStudent(student, completionHandler: { (guardians) in
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
                                    let guardian = Guardian(id: StringsMechanisms.generateID(), profileID: id, name: guardianName, surname: guardianSurname, gender: gender, email: email, students: [student])
                                    serverGuardians.append(guardian)
                                }
                                let comparison = self.compareGuardians(serverGuardians, localGuardians: localGuardians)
                                let wasChanged = comparison["wasChanged"]
                                let wasDeleted = comparison["wasDeleted"]
                                let newGuardians = comparison["newGuardians"]
                                if newGuardians!.count > 0 {
                                    GuardianDAO.createGuardians(newGuardians!, completionHandler: { (write) in
                                        do {
                                            try write()
                                            let message = NotificationMessage()
                                            message.setDataToInsert(newGuardians!)
                                            dispatch_async(dispatch_get_main_queue(), {
                                                NinoNotificationManager.sharedInstance.addGuardiansUpdatedNotification(self, error: nil, info: message)
                                            })
                                        } catch let error {
                                            //TODO: handle Realm error
                                            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
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
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                })
            } catch let error {
                //TODO: handle missing id error
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    static func getGuardian(completionHandler: (getProfile: () throws -> Guardian) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(getProfile: { () -> Guardian in
                    throw AccountError.InvalidToken
                })
            })
            return
        }
        
        AccountMechanism.getMyProfile(nil, token: token) { (profileID, name, surname, birthDate, gender, error, data) in
            var userName = ""
            if let serverName = name {
                userName = serverName
            }
            var userSurname = ""
            if let serverSurname = surname {
                userSurname = serverSurname
            }
            var userGender: Gender?
            if let serverGender = gender {
                userGender = Gender(rawValue: serverGender)
            }
            guard let userID = profileID else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(getProfile: { () -> Guardian in
                        throw RealmError.UnexpectedCase
                    })
                })
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(getProfile: { () -> Guardian in
                    return Guardian(id: StringsMechanisms.generateID(), profileID: userID, name: userName, surname: userSurname, gender: userGender, email: "", students: [])//TODO: Put Students and email
                })
            })
            return
        }
    }
    
    static func updateNameAndSurname(name: String, surname: String, completionHandler: (id: () throws -> Int) -> Void) {
        
        guard let token = NinoSession.sharedInstance.credential?.token else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(id: { () -> Int in
                    throw AccountError.InvalidToken
                })
            })
            return
        }
        
        GuardianMechanism.updateNameAndSurname(token, name: name, surname: surname) { (info, error, data) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(id: { () -> Int in
                        throw ErrorBO.decodeServerError(error)
                    })
                })
            }
            guard let updatedProfile = info else {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(id: { () -> Int in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            guard let id = updatedProfile["id"] as? Int else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(id: { () -> Int in
                        throw ServerError.UnexpectedCase
                    })
                })
                return
            }
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(id: { () -> Int in
                    return id
                })
            })
        }
    }
    
    static func getStudents(token: String, completionHandler: (students: () throws -> [Student]) -> Void) {
        GuardianDAO.getStudents { (students) in
            do {
                let students = try students()
                if students.count > 0 { //TODO check if something new
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(students: { () -> [Student] in
                            return students
                        })
                    })
                } else {
                    GuardianMechanism.getStudents(token, completionHandler: { (info, error, data) in
                        if let error = error {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(students: { () -> [Student] in
                                    throw ErrorBO.decodeServerError(error)
                                })
                            })
                        }
                        guard let students = info else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(students: { () -> [Student] in
                                    throw DatabaseError.NotFound
                                })
                            })
                            return
                        }
                        var studentsVO: [Student] = []
                        for student in students {
                            guard let studentID = (student["id"] as? Int) else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }
                            guard let studentName = (student["name"] as? String) else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }
                            guard let studentSurname = (student["surname"] as? String) else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }
                            guard let studentGender = (student["gender"] as? Int) else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }
                            guard let studentRoom = (student["room"] as? Int) else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }
                            guard let studentBirthdate = (student["birthdate"] as? NSDate) else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }
                            guard let createdAt = student["createdAt"] as? NSDate? else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }
                            guard let gender = Gender(rawValue: studentGender) else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(students: { () -> [Student] in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                return
                            }

                            RoomBO.getRoom(studentRoom, completionHandler: { (room) in
                                do {
                                    let room = try room()
                                    let studentVO = Student(id: StringsMechanisms.generateID(), profileId: studentID, name: studentName, surname: studentSurname, gender: gender, birthDate: studentBirthdate, profilePicture: nil, roomID: room.id, guardians: nil, createdAt: createdAt)
                                    //TODO: Help
                                    studentsVO.append(studentVO)
                                    if (studentsVO.count == students.count) { //FIXME: Fix this, need to check for updates too
                                        StudentDAO.createStudents(studentsVO, roomID: room.id, completionHandler: { (write) in
                                            do {
                                                try write()
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    completionHandler(students: { () -> [Student] in
                                                        return studentsVO
                                                    })
                                                })
                                            } catch let error {
                                                print("realm school error")
                                                //TODO: post notification
                                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                            }
                                        })
                                    }
                                } catch let error {
                                    //TODO: Handle error
                                    NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                }
                            })
                        }
                    })
                }
            } catch let error {
                //TODO Handle error
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
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
