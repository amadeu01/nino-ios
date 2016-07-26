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
    
    private var school: SchoolRealmObject?
    
    private override init() {
        super.init()
    }
    
    func createSchool(school: School, completionHandler: (writeSchool: () throws -> Void) -> Void) {
        //new school attributes
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
        RealmManager.sharedInstace.writeObjects([newSchool]) { (write) in
            do {
                try write()
                //success
                self.school = newSchool
                completionHandler(writeSchool: { 
                    return
                })
            } catch let error {
                completionHandler(writeSchool: { 
                    throw error
                })
            }
        }
    }
    
    func getSchool(completionHandler: (school: () throws -> School) -> Void) {
        guard let school = self.school else {
            //try to find in database
            RealmManager.sharedInstace.getObjects(SchoolRealmObject.self, filter: nil, completionHandler: { (retrieve) in
                do {
                    let schools = try retrieve()
                    guard let school = schools.first else {
                        completionHandler(school: { () -> School in
                            throw DatabaseError.NotFound
                        })
                        return
                    }
                    self.school = school
                    completionHandler(school: { () -> School in
                        return School(id: school.id, schoolId: school.schoolID.value, name: school.name, address: school.address, legalNumber: school.legalNumber, telephone: school.telephone, email: school.email, owner: school.ownerID.value, logo: school.logo)
                    })
                } catch let error {
                    completionHandler(school: { () -> School in
                        throw error
                    })
                }
            })
            return
        }
        //school already loaded
        completionHandler { () -> School in
            return School(id: school.id, schoolId: school.schoolID.value, name: school.name, address: school.address, legalNumber: school.legalNumber, telephone: school.telephone, email: school.email, owner: school.ownerID.value, logo: school.logo)
        }
    }
    
    func getIdForSchool(id: String, completionHandler: (id: () throws -> Int) -> Void) {
        var error: ErrorType? = nil
        //block to run before leave the method
        defer {
            //realm error
            if let err = error {
                completionHandler(id: { () -> Int in
                    throw err
                })
            } else {
                if self.school?.id == id {
                    //has id
                    if let serverID = self.school?.schoolID.value {
                        completionHandler(id: { () -> Int in
                            return serverID
                        })
                    }
                    //missing id
                    else {
                        completionHandler(id: { () -> Int in
                            throw DatabaseError.MissingID
                        })
                    }
                }
                //wrong id
                else {
                    completionHandler(id: { () -> Int in
                        throw DatabaseError.ConflictingIDs
                    })
                }
            }
        }
        guard self.school != nil else {
            RealmManager.sharedInstace.getObjects(SchoolRealmObject.self, filter: nil, completionHandler: { (retrieve) in
                do {
                    let schools = try retrieve()
                    guard let school = schools.first else {
                        error = DatabaseError.NotFound
                        return
                    }
                    self.school = school
                } catch let realmError {
                    error = realmError
                }
            })
            return
        } //end guard
    }
    
    func updateSchoolId(id: Int, completionHandler: (update: () throws -> Void) -> Void) {
        var error: ErrorType? = nil
        defer {
            //error
            if let err = error {
                completionHandler(update: { 
                    throw err
                })
            }
            //success
            else {
                self.school?.schoolID.value = id
                RealmManager.sharedInstace.writeObjects([self.school!], completionHandler: { (write) in
                    do {
                        try write()
                        //updated
                        completionHandler(update: { 
                            return
                        })
                    }
                    //realm error
                    catch let err {
                        completionHandler(update: { 
                            throw err
                        })
                    }
                })
            }
        }
        guard self.school != nil else {
            RealmManager.sharedInstace.getObjects(SchoolRealmObject.self, filter: nil, completionHandler: { (retrieve) in
                do {
                    let schools = try retrieve()
                    guard let school = schools.first else {
                        error = DatabaseError.NotFound
                        return
                    }
                    self.school = school
                    
                } catch let realmError {
                    error = realmError
                }
            })
            return
        }//end guard
    }
    
    func updateSchoolLogo(logo: NSData, completionHandler: (update: () throws -> Void) -> Void) {
        var error: ErrorType? = nil
        defer {
            //error
            if let err = error {
                completionHandler(update: { 
                    throw err
                })
            }
            //success
            else {
                self.school?.logo = logo
                RealmManager.sharedInstace.writeObjects([self.school!], completionHandler: { (write) in
                    do {
                        try write()
                        //updated
                        completionHandler(update: {
                            return
                        })
                    }
                        //realm error
                    catch let err {
                        completionHandler(update: {
                            throw err
                        })
                    }
                })
            }
        }
        guard self.school != nil else {
            RealmManager.sharedInstace.getObjects(SchoolRealmObject.self, filter: nil, completionHandler: { (retrieve) in
                do {
                    let schools = try retrieve()
                    guard let school = schools.first else {
                        error = DatabaseError.NotFound
                        return
                    }
                    self.school = school
                    
                } catch let realmError {
                    error = realmError
                }
            })
            return
        }//end guard
    }
    
}
