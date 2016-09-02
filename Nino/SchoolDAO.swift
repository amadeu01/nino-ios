//
//  SchoolDAO.swift
//  Nino
//
//  Created by Danilo Becke on 22/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class SchoolDAO: NSObject {
    
    private override init() {
        super.init()
    }
    
    static func createSchool(school: School, completionHandler: (writeSchool: () throws -> Void) -> Void) {
        //new school attributes
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            let newSchool = SchoolRealmObject()
            newSchool.id = school.id
            newSchool.name = school.name
            newSchool.address = school.address
            newSchool.telephone = school.telephone
            newSchool.email = school.email
            newSchool.schoolID.value = school.schoolID
            newSchool.legalNumber = school.legalNumber
            newSchool.ownerID.value = school.owner
            newSchool.logo = school.logo
            //write object
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(newSchool)
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(writeSchool: {
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(writeSchool: {
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getSchool(completionHandler: (school: () throws -> School) -> Void) {
        //try to find in database
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let schools = realm.objects(SchoolRealmObject.self)
                guard let school = schools.first else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(school: { () -> School in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let schoolVO = School(id: school.id, schoolId: school.schoolID.value, name: school.name, address: school.address, legalNumber: school.legalNumber, telephone: school.telephone, email: school.email, owner: school.ownerID.value, logo: school.logo)
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(school: { () -> School in
                        return schoolVO
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(school: { () -> School in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getIdForSchool(completionHandler: (id: () throws -> Int) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue(), {
            do {
                let realm = try Realm()
                let schools = realm.objects(SchoolRealmObject.self)
                guard let school = schools.first else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(id: { () -> Int in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                guard let schoolID = school.schoolID.value else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(id: { () -> Int in
                            throw DatabaseError.MissingID
                        })
                    })
                    return
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(id: { () -> Int in
                        return schoolID
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(id: { () -> Int in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        })
    }
    
    static func updateSchoolId(id: Int, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue(), {
            do {
                let realm = try Realm()
                let schools = realm.objects(SchoolRealmObject.self)
                guard let school = schools.first else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(update: {
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                try realm.write({
                    school.schoolID.value = id
                    realm.add(school, update: true)
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
        })
    }
    
    static func updateSchoolLogo(logo: NSData, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue(), {
            do {
                let realm = try Realm()
                let schools = realm.objects(SchoolRealmObject.self)
                guard let school = schools.first else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(update: {
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                try realm.write({
                    school.logo = logo
                    realm.add(school, update: true)
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
        })
    }
    
}
