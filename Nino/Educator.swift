//
//  Educator.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

struct Educator {

//MARK: Attributes
    let id: Int
    let name: String
    let surname: String
    var schools: [School]?
    var grades: [Grade]?
    var rooms: [Room]?

//MARK: Initializer
    /**
     Initialize one educator

     - parameter id:      unique identifier
     - parameter name:    educator's name
     - parameter surname: educator's surname
     - parameter school:  optional list of schools
     - parameter grades:  optional list of grades
     - parameter rooms:   optional list of rooms

     - returns: struct VO of Guardian type
     */
    init(id: Int, name: String, surname: String, school: [School]?, grades: [Grade]?, rooms: [Room]?) {
        self.id = id
        self.name = name
        self.surname = surname
        if let institution = school {
            self.schools = institution
        }
        if let classes = grades {
            self.grades = classes
        }
        if let place = rooms {
            self.rooms = place
        }
    }
}
