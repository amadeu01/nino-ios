//
//  School.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one school
 */
struct School {

//MARK: Attributes
    let id: String
    let schoolID: Int?
    let name: String
    let address: String
    let legalNumber: String?
    let telephone: String
    let email: String
    let owner: Int?
    let logo: NSData?

//MARK: Initializer
    /**
     Initialize one school

     - parameter id:         school ID
     - parameter schoolId:   server unique identifier
     - parameter name:       school's name
     - parameter address:    school's address
     - parameter legalNumber:optional school's legal number
     - parameter telephone:  school's phone
     - parameter email:      school's main email
     - parameter owner:      optional id of the owner of the school
     - parameter logo:       optional school's logo

     - returns: struct VO of School type
     */
    init(id: String, schoolId: Int?, name: String, address: String, legalNumber: String?, telephone: String, email: String, owner: Int?, logo: NSData?) {
        self.id = id
        self.schoolID = schoolId
        self.name = name
        self.address = address
        self.legalNumber = legalNumber
        self.email = email
        self.telephone = telephone
        self.owner = owner
        self.logo = logo
    }
}
