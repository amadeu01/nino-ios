//
//  RoomBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all sevices of phases
class RoomBO: NSObject {

    /**
     Tries to create a Room
     
     - parameter id:         unique identifier
     - parameter phase:      room's phase
     - parameter name:       room's name
     - parameter educators:  optional list of educators
     - parameter calendar:   optional calendar
     - parameter students:   optional list of students
     
     - returns: Room VO
     */
    static func createRoom(id: Int, phase: Phase, name: String, educators: [Educator]?, calendar: Calendar?, students: [Student]?) -> Room {
        return Room(id: id, phase: phase, name: name, educators: educators, calendar: calendar, students: students)
    }
}
