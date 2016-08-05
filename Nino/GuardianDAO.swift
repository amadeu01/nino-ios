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
    
    static let sharedInstance = GuardianDAO()
    
    private override init() {
        super.init()
    }
    
    func createGuardians(guardians: [Guardian], completionHandler: (write: () throws -> Void) -> Void) {
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

    func getGuardiansForStudent(student: String, completionHandler: (guardians: () throws -> [Guardian]) -> Void) {
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
    
    func updateGuardianID(guardian: String, id: Int, completionHandler: (update: () throws -> Void) -> Void) {
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
