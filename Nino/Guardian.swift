//
//  Guardian.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one Guardian
 */
struct Guardian {

//MARK: Attributes
    let id: String
    let profileID: Int?
    let name: String
    let surname: String
    let gender: Gender?
    let email: String
    let students: [String]

//MARK: Initializer
    /**
     Initialize one guardian

     - parameter id:            guardian ID
     - parameter profileID:     server profile unique identifier
     - parameter name:          guardian's name
     - parameter surname:       guardian's surname
     - parameter gender:        guardian's gender
     - parameter email:         guardian's email
     - parameter students:      optional list of students idsguardianID

     - returns: struct VO of Guardian type
     */
    init(id: String, profileID: Int?, name: String, surname: String, gender: Gender?, email: String, students: [String]) {
        self.id = id
        self.name = name
        self.surname = surname
        self.gender = gender
        self.email = email
        self.students = students
        self.profileID = profileID
    }
}
