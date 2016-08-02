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

    static let sharedInstance = SchoolDAO()
    
    private var school: School?
    
    private override init() {
        super.init()
    }
    
    func createSchool(school: School, completionHandler: (writeSchool: () throws -> Void) -> Void) {
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
                self.school = school
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
    
    func getSchool(completionHandler: (school: () throws -> School) -> Void) {
        guard let school = self.school else {
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
                    self.school = School(id: school.id, schoolId: school.schoolID.value, name: school.name, address: school.address, legalNumber: school.legalNumber, telephone: school.telephone, email: school.email, owner: school.ownerID.value, logo: school.logo)
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(school: { () -> School in
                            return self.school!
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
            return
        }
        //school already loaded
        completionHandler { () -> School in
            return school
        }
    }
    
    func getIdForSchool(completionHandler: (id: () throws -> Int) -> Void) {
        
        if self.school == nil {
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
        } else {
            guard let schoolID = self.school!.schoolID else {
                //missing schoolID
                completionHandler(id: { () -> Int in
                    throw DatabaseError.MissingID
                })
                return
            }
            //school already loaded
            completionHandler(id: { () -> Int in
                return schoolID
            })
        }
    }
    
    func updateSchoolId(id: Int, completionHandler: (update: () throws -> Void) -> Void) {
        guard var school = self.school else {
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
                    self.school = School(id: school.id, schoolId: school.schoolID.value, name: school.name, address: school.address, legalNumber: school.legalNumber, telephone: school.telephone, email: school.email, owner: school.ownerID.value, logo: school.logo)
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
            return
        }
        school.schoolID = id
        self.school = school
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
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
                try realm.write({
                    realm.add(newSchool, update: true)
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
    
    func updateSchoolLogo(logo: NSData, completionHandler: (update: () throws -> Void) -> Void) {
        guard var school = self.school else {
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
                    self.school = School(id: school.id, schoolId: school.schoolID.value, name: school.name, address: school.address, legalNumber: school.legalNumber, telephone: school.telephone, email: school.email, owner: school.ownerID.value, logo: school.logo)
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
            return
        }
        school.logo = logo
        self.school = school
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
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
                try realm.write({
                    realm.add(newSchool, update: true)
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
