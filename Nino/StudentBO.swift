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

    /**
     Tries to create a student

     - parameter id:             unique identifier
     - parameter name:           student's first name
     - parameter surname:        student's surname
     - parameter gender:         student's gender
     - parameter birthDate:      student's birth date
     - parameter profilePicture: optional student's profile picture
     - parameter school:         optional student's school
     - parameter phase:          optional student's phase
     - parameter room:           optional student's room
     - parameter guardian:       optional list of guardians
     - parameter post:           optional list of posts

     - throws: error of CreationError.InvalidBirthDate type

     - returns: struct VO of Student type
     */
//    static func createStudent(name: String, surname: String, gender: Gender, birthDate: NSDate, profilePicture: NSData?, school: School?, phase: Phase?, room: Room?, guardian: [Guardian]?, post: [Post]?) throws -> Student {
//        
//        if birthDate.compare(NSDate()) == NSComparisonResult.OrderedDescending {
//            throw CreationError.InvalidBirthDate
//        }
//        
//    }
    
    static func getStudent(token: String, roomID: String, completionHandler: (students: () throws -> [Student]) -> Void) {
        do {
            let room = try RoomBO.getIdForRoom(roomID)
            StudentMechanism.getStudents(token, roomID: room) { (info, error, data) in
                if let errorType = error {
                    //TODO: Handle error data and code
                    completionHandler(students: { () -> [Student] in
                        throw ErrorBO.decodeServerError(errorType)
                    })
                } else if let studentsInfo = info {
                    var students = [Student]()
                    for dict in studentsInfo {
                        let id = dict["profileID"] as? Int
                        let name = dict["name"] as? String
                        let surname = dict["surname"] as? String
                        let birthDate = dict["birthdate"] as? NSDate
                        let gender = dict["gender"] as? Int
                        guard let studentID = id else {
                            completionHandler(students: { () -> [Student] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        guard let studentName = name else {
                            completionHandler(students: { () -> [Student] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        guard let studentSurname = surname else {
                            completionHandler(students: { () -> [Student] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        guard let studentBirthDate = birthDate else {
                            completionHandler(students: { () -> [Student] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        guard let studentIntGender = gender else {
                            completionHandler(students: { () -> [Student] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        guard let studentGender = Gender(rawValue: studentIntGender) else {
                            completionHandler(students: { () -> [Student] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        let student = Student(id: StringsMechanisms.generateID(), profileId: studentID, name: studentName, surname: studentSurname, gender: studentGender, birthDate: studentBirthDate, profilePicture: nil, roomID: room, guardians: nil)
                        students.append(student)
                    }
                    completionHandler(students: { () -> [Student] in
                        return students
                    })
                }
                    //unexpected case
                else {
                    completionHandler(students: { () -> [Student] in
                        throw ServerError.UnexpectedCase
                    })
                }
            }
        } catch {
            //TODO: throw room not found error
        }
    }

}
