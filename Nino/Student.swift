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
    let id: Int
    let name: String
    let surname: String
    let gender: Gender
    let birthDate: NSDate
    var profilePicture: NSData?
    var school: School?
    var grade: Grade?
    var room: Room?
    var guardian: [Guardian]?
    var post: [Post]?
    
//MARK: Initializer
    /**
     Initialize one student

     - parameter id:             unique identifier
     - parameter name:           student's first name
     - parameter surname:        student's surname
     - parameter gender:         student's gender
     - parameter birthDate:      student's birth date
     - parameter profilePicture: optional student's profile picture
     - parameter school:         optional student's school
     - parameter grade:          optional student's grade
     - parameter room:           optional student's room
     - parameter guardian:       optional list of guardians
     - parameter post:           optional list of posts

     - returns: struct VO of Student type
     */
    init(id: Int, name: String, surname: String, gender: Gender, birthDate: NSDate, profilePicture: NSData?, school: School?, grade: Grade?, room: Room?, guardian: [Guardian]?, post: [Post]?) {
        self.id = id
        self.name = name
        self.surname = surname
        self.gender = gender
        self.birthDate = birthDate
        if let picture = profilePicture {
            self.profilePicture = picture
        }
        if let institution = school {
            self.school = institution
        }
        if let level = grade {
            self.grade = level
        }
        if let place = room {
            self.room = place
        }
        if let sponsor = guardian {
            self.guardian = sponsor
        }
        if let postage = post {
            self.post = postage
        }
    }

    
}
