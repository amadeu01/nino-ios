//
//  StudentDAO.swift
//  Nino
//
//  Created by Danilo Becke on 05/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class StudentDAO: NSObject {
    
    override private init() {
        super.init()
    }
    
    static func createStudents(students: [Student], roomID: String, completionHandler: (write: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let room = realm.objectForPrimaryKey(RoomRealmObject.self, key: roomID)
                guard let selectedRoom = room else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(write: { 
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                var realmStudents = [StudentRealmObject]()
                for student in students {
                    let realmStudent = StudentRealmObject()
                    realmStudent.name = student.name
                    realmStudent.surname = student.surname
                    realmStudent.birthdate = student.birthDate
                    realmStudent.gender = student.gender.rawValue
                    realmStudent.id = student.id
                    realmStudent.profileID.value = student.profileID
                    realmStudent.profilePicture = student.profilePicture
                    realmStudent.room = selectedRoom
                    realmStudent.school = selectedRoom.phase?.school
                    realmStudent.createdAt = student.createdAt
                    realmStudents.append(realmStudent)
                }
                try realm.write({ 
                    for student in realmStudents {
                        realm.add(student)
                    }
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(write: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(write: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func updateStudentID(student: String, profileID: Int, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let student = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = student else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(update: { 
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                try realm.write({ 
                    selectedStudent.profileID.value = profileID
                    realm.add(selectedStudent, update: true)
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(update: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(update: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getStudentsForRoom(roomID: String, completionHandler: (students: () throws -> [Student]) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let room = realm.objectForPrimaryKey(RoomRealmObject.self, key: roomID)
                guard let selectedRoom = room else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(students: { () -> [Student] in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                var students = [Student]()
                for student in selectedRoom.students {
                    var guardians: [String]?
                    for guardian in student.guardians {
                        if guardians == nil {
                            guardians = [String]()
                        }
                        guardians?.append(guardian.id)
                    }
                    let innerStudent = Student(id: student.id, profileId: student.profileID.value, name: student.name, surname: student.surname, gender: Gender(rawValue: student.gender)!, birthDate: student.birthdate, profilePicture: student.profilePicture, roomID: student.room!.id, guardians: guardians, createdAt: student.createdAt)
                    students.append(innerStudent)
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(students: { () -> [Student] in
                        return students
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(students: { () -> [Student] in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getStudentForId(id: String, completionHandler: (student: () throws -> Student) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let realmStudent = realm.objectForPrimaryKey(StudentRealmObject.self, key: id)
                guard let student = realmStudent else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(student: { () -> Student in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                
                var guardians: [String]?
                for guardian in student.guardians {
                    if guardians == nil {
                        guardians = [String]()
                    }
                    guardians?.append(guardian.id)
                }
                let studentVO = Student(id: student.id, profileId: student.profileID.value, name: student.name, surname: student.surname, gender: Gender(rawValue: student.gender)!, birthDate: student.birthdate, profilePicture: student.profilePicture, roomID: student.room!.id, guardians: guardians, createdAt: student.createdAt)

                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(student: { () -> Student in
                        return studentVO
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(student: { () -> Student in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }

    }
    
    static func getStudentID(student: String, completionHandler: (id: () throws -> Int) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let realmStudent = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = realmStudent else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(id: { () -> Int in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let id = selectedStudent.profileID.value
                guard let studentID = id else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(id: { () -> Int in
                            throw DatabaseError.MissingID
                        })
                    })
                    return
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(id: { () -> Int in
                        return studentID
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(id: { () -> Int in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func updateCreatedAt(student: String, createdAt: NSDate, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let studentRealm = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = studentRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(update: { 
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                try realm.write({ 
                    selectedStudent.createdAt = createdAt
                    realm.add(selectedStudent, update: true)
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(update: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(update: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func deleteStudent(student: String, completionHandler: (delete: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let student = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                if let selectedStudent = student {
                    try realm.write({
                        realm.delete(selectedStudent)
                    })
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(delete: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(delete: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
}
