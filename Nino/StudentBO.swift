//
//  StudentBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all student's services
class StudentBO: NSObject {

    /**
     Try to create a student

     - parameter id:             unique identifier
     - parameter name:           student's first name
     - parameter surname:        student's surname
     - parameter gender:         student's gender
     - parameter birthDate:      student's birth date
     - parameter profilePicture: optional student's profile picture
     - parameter school:         optional student's school
     - parameter phase:          optional student's phase
     - parameter room:           optional student's room
     - parameter guardian:       optional list of guardians
     - parameter post:           optional list of posts

     - throws: error of CreationError.InvalidBirthDate type

     - returns: struct VO of Student type
     */
    static func createStudent(id: Int, name: String, surname: String, gender: Gender, birthDate: NSDate, profilePicture: NSData?, school: School?, phase: Phase?, room: Room?, guardian: [Guardian]?, post: [Post]?) throws -> Student {
        if birthDate.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            throw CreationError.InvalidBirthDate
        }
        return Student(id: id, name: name, surname: surname, gender: gender, birthDate: birthDate, profilePicture: profilePicture, school: school, phase: phase, room: room, guardian: guardian, post: post)
    }

}
