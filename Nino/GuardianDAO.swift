//
//  GuardianDAO.swift
//  Nino
//
//  Created by Danilo Becke on 05/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class GuardianDAO: NSObject {
    
    private override init() {
        super.init()
    }
    
    static func getGuardianForId(id: String, completionHandler: (guardian: () throws -> Guardian) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let realmGuardian = realm.objectForPrimaryKey(GuardianRealmObject.self, key: id)
                guard let guardian = realmGuardian else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(guardian: { () -> Guardian in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                var guardianGender : Gender?
                if let gender = guardian.gender.value {
                    guardianGender = Gender(rawValue: gender)
                }
                
                var students = [String]()
                for student in guardian.students {
                    students.append(student.id)
                }
                
                let guardianVO = Guardian(id: guardian.id, profileID: guardian.profileID.value, name: guardian.name, surname: guardian.surname, gender: guardianGender, email: guardian.email, students: students)
                
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(guardian: { () -> Guardian in
                        return guardianVO
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(guardian: { () -> Guardian in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
        
    }
    
    static func createGuardians(guardians: [Guardian], completionHandler: (write: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                for guardian in guardians {
                    let realmGuardian = GuardianRealmObject()
                    realmGuardian.name = guardian.name
                    realmGuardian.surname = guardian.surname
                    realmGuardian.email = guardian.email
                    realmGuardian.id = guardian.id
                    realmGuardian.profileID.value = guardian.profileID
                    realmGuardian.gender.value = guardian.gender?.rawValue
                    //get realm objects for each student
                    for student in guardian.students {
                        let studentRealm = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                        guard let targetStudent = studentRealm else {
                            dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                                completionHandler(write: { 
                                    throw DatabaseError.NotFound
                                })
                            })
                            return
                        }
                        realmGuardian.students.append(targetStudent)
                    }
                    try realm.write({ 
                        realm.add(realmGuardian)
                    })
                } //end guardians loop
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

    static func getGuardiansForStudent(student: String, completionHandler: (guardians: () throws -> [Guardian]) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let realmStudent = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = realmStudent else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(guardians: { 
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                var guardians = [Guardian]()
                for realmGuardian in selectedStudent.guardians {
                    var gender: Gender?
                    var students = [String]()
                    if let guardianGender = realmGuardian.gender.value {
                        gender = Gender(rawValue: guardianGender)
                    }
                    for student in realmGuardian.students {
                        students.append(student.id)
                    }
                    let guardian = Guardian(id: realmGuardian.id, profileID: realmGuardian.profileID.value, name: realmGuardian.name, surname: realmGuardian.surname, gender: gender, email: realmGuardian.email, students: students)
                    guardians.append(guardian)
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(guardians: { 
                        return guardians
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(guardians: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getStudents(completionHandler: (students: () throws -> [Student]) -> Void) {
        //try to find in database
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let students = realm.objects(StudentRealmObject.self)
                var studentsVO: [Student] = []
                for student in students {
                    guard let studentGender = Gender(rawValue: student.gender) else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(students: { () -> [Student] in
                                throw RealmError.UnexpectedCase
                            })
                        })
                        return
                    }
                    guard let roomID = student.room?.id else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(students: { () -> [Student] in
                                throw RealmError.UnexpectedCase
                            })
                        })
                        return
                    }
                    var guardians: [String] = []
                    for guardian in student.guardians {
                        guardians.append(guardian.id)
                    }
                    let studentVO = Student(id: student.id, profileId: student.profileID.value, name: student.name, surname: student.surname, gender: studentGender, birthDate: student.birthdate, profilePicture: student.profilePicture, roomID: roomID, guardians: guardians, createdAt: student.createdAt)
                    studentsVO.append(studentVO)
                }
                
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(students: { () -> [Student] in
                        return studentsVO
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
    
    static func updateGuardians(guardians: [Guardian], completionHandler: (update: () throws -> Void) -> Void) -> Void {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                for guardian in guardians {
                    var realmGuardian : GuardianRealmObject?
                    if let profileID = guardian.profileID {
                        realmGuardian = realm.objects(GuardianRealmObject.self).filter("profileID = \(profileID)").first
                    } else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(update: {
                                throw DatabaseError.MissingID
                            })
                        })
                        return
                    }
                    guard let selectedGuardian = realmGuardian else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(update: {
                                throw DatabaseError.NotFound
                            })
                        })
                        return
                    }
                    try realm.write({
                        selectedGuardian.name = guardian.name
                        selectedGuardian.surname = guardian.surname
                        selectedGuardian.email = guardian.email
                        //TODO: Gender is let but BO checks if updated
//                        selectedGuardian.gender = guardian.gender
                    })
                }
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(update: {
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func updateGuardianID(guardian: String, id: Int, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let realmGuardian = realm.objectForPrimaryKey(GuardianRealmObject.self, key: guardian)
                guard let selectedGuardian = realmGuardian else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(update: { 
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                try realm.write({ 
                    selectedGuardian.profileID.value = id
                    realm.add(selectedGuardian, update: true)
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
}
