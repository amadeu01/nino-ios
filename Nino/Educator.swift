//
//  Educator.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one Educator
 */
struct Educator {

//MARK: Attributes
    let id: Int
    let name: String
    let surname: String
    let email: String
    var schools: [School]?
    var phases: [Phase]?
    var rooms: [Room]?

//MARK: Initializer
    /**
     Initialize one educator

     - parameter id:      unique identifier
     - parameter name:    educator's name
     - parameter surname: educator's surname
     - parameter email:   educator's email
     - parameter school:  optional list of schools
     - parameter phases:  optional list of phases
     - parameter rooms:   optional list of rooms

     - returns: struct VO of Guardian type
     */
    init(id: Int, name: String, surname: String, email: String, school: [School]?, phases: [Phase]?, rooms: [Room]?) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        if let institution = school {
            self.schools = institution
        }
        if let classes = phases {
            self.phases = classes
        }
        if let place = rooms {
            self.rooms = place
        }
    }
}
