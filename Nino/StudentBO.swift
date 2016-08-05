//
//  StudentBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all student's services
class StudentBO: NSObject {
    
    static func createStudent(roomID: String, name: String, surname: String, birthDate: NSDate, gender: Gender, profilePictue: NSData?, completionHandler: (student: () throws -> Student) -> Void) {
        
        if birthDate.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            completionHandler(student: { () -> Student in
                throw CreationError.InvalidBirthDate
            })
            return
        }
        guard let token = NinoSession.sharedInstance.credential?.token else {
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(student: { () -> Student in
                    throw AccountError.InvalidToken
                })
            })
            return
        }
        SchoolBO.getIdForSchool { (id) in
            do {
                let school = try id()
                let room = try RoomBO.getIdForRoom(roomID)
                var student = Student(id: StringsMechanisms.generateID(), profileId: nil, name: name, surname: surname, gender: gender, birthDate: birthDate, profilePicture: profilePictue, roomID: roomID, guardians: nil)
                StudentDAO.sharedInstance.createStudents([student], roomID: roomID, completionHandler: { (write) in
                    do {
                        try write()
                        StudentMechanism.createStudent(token, schoolID: school, roomID: room, name: name, surname: surname, birthDate: birthDate, gender: gender.rawValue) { (profileID, error, data) in
                            if let err = error {
                                //TODO: handle error data
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(student: { () -> Student in
                                        throw ErrorBO.decodeServerError(err)
                                    })
                                })
                            } else if let studentID = profileID {
                                StudentDAO.sharedInstance.updateStudentID(student.id, profileID: studentID, completionHandler: { (update) in
                                    do {
                                        try update()
                                        student.profileID = studentID
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(student: { () -> Student in
                                                return student
                                            })
                                        })
                                    } catch {
                                        //TODO: handle realm error
                                    }
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(student: { () -> Student in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                            }
                        }
                    } catch {
                        //TODO: handle realm error
                    }
                })
            } catch {
                //TODO: missing schoolID or roomID
            }
        }
    }
    
    static func getStudent(roomID: String, completionHandler: (students: () throws -> [Student]) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(students: { () -> [Student] in
                    throw AccountError.InvalidToken
                })
            })
            return
        }
        do {
            let room = try RoomBO.getIdForRoom(roomID)
            StudentDAO.sharedInstance.getStudentsForRoom(roomID, completionHandler: { (students) in
                do {
                    let localStudents = try students()
                    dispatch_async(dispatch_get_main_queue(), { 
                        completionHandler(students: { () -> [Student] in
                            return localStudents
                        })
                    })
                    StudentMechanism.getStudents(token, roomID: room) { (info, error, data) in
                        if let errorType = error {
                            //TODO: Handle error data and code
                            let message = NotificationMessage()
                            message.setServerError(ErrorBO.decodeServerError(errorType))
                            dispatch_async(dispatch_get_main_queue(), {
                                NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                            })
                        } else if let studentsInfo = info {
                            var serverStudents = [Student]()
                            for dict in studentsInfo {
                                let id = dict["profileID"] as? Int
                                let name = dict["name"] as? String
                                let surname = dict["surname"] as? String
                                let birthDate = dict["birthdate"] as? NSDate
                                let gender = dict["gender"] as? Int
                                guard let studentID = id else {
                                    let message = NotificationMessage()
                                    message.setServerError(ServerError.UnexpectedCase)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                                    })
                                    return
                                }
                                guard let studentName = name else {
                                    let message = NotificationMessage()
                                    message.setServerError(ServerError.UnexpectedCase)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                                    })
                                    return
                                }
                                guard let studentSurname = surname else {
                                    let message = NotificationMessage()
                                    message.setServerError(ServerError.UnexpectedCase)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                                    })
                                    return
                                }
                                guard let studentBirthDate = birthDate else {
                                    let message = NotificationMessage()
                                    message.setServerError(ServerError.UnexpectedCase)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                                    })
                                    return
                                }
                                guard let studentIntGender = gender else {
                                    let message = NotificationMessage()
                                    message.setServerError(ServerError.UnexpectedCase)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                                    })
                                    return
                                }
                                guard let studentGender = Gender(rawValue: studentIntGender) else {
                                    let message = NotificationMessage()
                                    message.setServerError(ServerError.UnexpectedCase)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                                    })
                                    return
                                }
                                let student = Student(id: StringsMechanisms.generateID(), profileId: studentID, name: studentName, surname: studentSurname, gender: studentGender, birthDate: studentBirthDate, profilePicture: nil, roomID: roomID, guardians: nil)
                                serverStudents.append(student)
                            }
                            let comparison = self.compareStudents(serverStudents, localStudents: localStudents)
                            let newStudents = comparison["newStudents"]
                            let wasChanged = comparison["wasChanged"]
                            let wasDeleted = comparison["wasDeleted"]
                            if newStudents!.count > 0 {
                                StudentDAO.sharedInstance.createStudents(newStudents!, roomID: roomID, completionHandler: { (write) in
                                    do {
                                        try write()
                                        let message = NotificationMessage()
                                        message.setDataToInsert(newStudents!)
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: nil, info: message)
                                        })
                                    } catch {
                                        //TODO: handle realm error
                                    }
                                })
                            }
                            //TODO: handle updated Students
                            //TODO: handle deleted Students
                        }
                        //unexpected case
                        else {
                            let message = NotificationMessage()
                            message.setServerError(ServerError.UnexpectedCase)
                            dispatch_async(dispatch_get_main_queue(), {
                                NinoNotificationManager.sharedInstance.addStudentsUpdatedNotification(self, error: message, info: nil)
                            })
                            return
                        }
                    }
                } catch {
                    //TODO: handle realm error
                }
            })
        } catch {
            //TODO: throw room not found error
        }
    }

    static func getIdForStudent(student: String, completionHandler: (id: () throws -> Int) -> Void) {
        StudentDAO.sharedInstance.getStudentID(student) { (id) in
            do {
                let studentID = try id()
                completionHandler(id: { () -> Int in
                    return studentID
                })
            } catch let error {
                completionHandler(id: { () -> Int in
                    throw error
                })
            }
        }
    }
    
    private static func compareStudents(serverStudents: [Student], localStudents: [Student]) -> [String: [Student]] {
        var result = [String: [Student]]()
        var wasChanged = [Student]()
        var newStudents = [Student]()
        var wasDeleted = [Student]()
        //check all room phases
        for serverStudent in serverStudents {
            var found = false
            //look for its similar
            for localStudent in localStudents {
                //found
                if serverStudent.profileID == localStudent.profileID {
                    found = true
                    //updated
                    if serverStudent.name != localStudent.name {
                        wasChanged.append(serverStudent)
                    }
                    if serverStudent.birthDate != localStudent.birthDate {
                        wasChanged.append(serverStudent)
                    }
                    if serverStudent.gender != localStudent.gender {
                        wasChanged.append(serverStudent)
                    }
                    if serverStudent.profilePicture != localStudent.profilePicture {
                        wasChanged.append(serverStudent)
                    }
                    if serverStudent.roomID != localStudent.roomID {
                        wasChanged.append(serverStudent)
                    }
                    if serverStudent.surname != localStudent.surname {
                        wasChanged.append(serverStudent)
                    }
                    break
                }
            }
            //not found locally
            if !found {
                newStudents.append(serverStudent)
            }
        }
        for localStudent in localStudents {
            var found = false
            for serverStudent in serverStudents {
                if localStudent.profileID == serverStudent.profileID {
                    found = true
                    break
                }
            }
            if !found {
                wasDeleted.append(localStudent)
            }
        }
        
        result["newStudents"] = newStudents
        result["wasChanged"] = wasChanged
        result["wasDeleted"] = wasDeleted
        return result
    }
    
}
