//
//  SchoolDAO.swift
//  Nino
//
//  Created by Danilo Becke on 22/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

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
    
//    func getSchool(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}
