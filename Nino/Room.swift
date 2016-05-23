//
//  Room.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one room
 */
struct Room {

//MARK: Attributes
    let id: Int
    let phase: Phase
    let name: String
    var educators: [Educator]?
    var calendar: Calendar?
    var students: [Student]?

//MARK: Initializer
    /**
     Initialize one room

     - parameter id:         unique identifier
     - parameter phase:      room's phase
     - parameter name:       room's name
     - parameter educators:  optional list of educators
     - parameter calendar:   optional calendar
     - parameter students:   optional list of students

     - returns: struct VO of Room type
     */
    init(id: Int, phase: Phase, name: String, educators: [Educator]?, calendar: Calendar?, students: [Student]?) {
        self.id = id
        self.phase = phase
        self.name = name
        if let caretakers = educators {
            self.educators = caretakers
        }
        if let schedule = calendar {
            self.calendar = schedule
        }
        if let babies = students {
            self.students = babies
        }
    }
}
