//
//  Student.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one student
 */
struct Student {
    
//MARK: Attributes
    let id: String
    let profileID: Int?
    let name: String
    let surname: String
    let gender: Gender
    let birthDate: NSDate
    let profilePicture: NSData?
    let roomID: String
    let guardians: [String]?
    
//MARK: Initializer
    /**
     Initialize one student

     - parameter id:             student ID
     - parameter profileID:      server profile identifier
     - parameter name:           student's first name
     - parameter surname:        student's surname
     - parameter gender:         student's gender
     - parameter birthDate:      student's birth date
     - parameter profilePicture: optional student's profile picture
     - parameter roomID:         student's roomID
     - parameter guardians:      optional list of guardians IDs

     - returns: struct VO of Student type
     */
    init(id: String, profileId: Int?, name: String, surname: String, gender: Gender, birthDate: NSDate, profilePicture: NSData?, roomID: String, guardians: [String]?) {
        self.id = id
        self.profileID = profileId
        self.name = name
        self.surname = surname
        self.gender = gender
        self.birthDate = birthDate
        self.profilePicture = profilePicture
        self.roomID = roomID
        if let guardianList = guardians {
            self.guardians = guardianList
        } else {
            self.guardians = [String]()
        }
    }

}
