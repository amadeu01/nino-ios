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
    var schoolID: Int?
    let name: String
    let address: String
    var legalNumber: String?
    let telephone: String
    let email: String
    var owner: Int?
    var logo: NSData?

//MARK: Initializer
    /**
     Initialize one school

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
    init(schoolId: Int?, name: String, address: String, legalNumber: String?, telephone: String, email: String, owner: Int?, logo: NSData?) {
        self.id = NSUUID().UUIDString
        if let schID = schoolID {
            self.schoolID = schID
        }
        self.name = name
        self.address = address
        if let cnpj = legalNumber {
            self.legalNumber = cnpj
        }
        self.email = email
        self.telephone = telephone
        if let ownerID = owner {
            self.owner = ownerID
        }
        if let picture = logo {
            self.logo = picture
        }
    }
}
