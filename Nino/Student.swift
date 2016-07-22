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
    var profileID: Int?
    let name: String
    let surname: String
    let gender: Gender
    let birthDate: NSDate
    var profilePicture: NSData?
    let roomID: Int
    var guardians: [String]?
    
//MARK: Initializer
    /**
     Initialize one student

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
    init(profileId: Int?, name: String, surname: String, gender: Gender, birthDate: NSDate, profilePicture: NSData?, roomID: Int, guardians: [String]?) {
        self.id = NSUUID().UUIDString
        if let profID = profileId {
            self.profileID = profID
        }
        self.name = name
        self.surname = surname
        self.gender = gender
        self.birthDate = birthDate
        if let picture = profilePicture {
            self.profilePicture = picture
        }
        self.roomID = roomID
        if let guardianList = guardians {
            self.guardians = guardianList
        } else {
            self.guardians = [String]()
        }
    }

}
