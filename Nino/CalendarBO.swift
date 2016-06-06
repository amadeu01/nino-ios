//
//  CalendarBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of calendar
class CalendarBO: NSObject {

    /**
     Tries to create a calendar
     
     - parameter id:     unique identifier
     - parameter school: optional school
     - parameter rooms:  optional list of rooms
     - parameter phases: optional list of phases
     - parameter events: optional list of events
     
     - throws: error of CreationError.TargetNotFound type
     
     - returns: Calendar VO
     */
    static func createCalendar(id: Int, school: School?, rooms: [Room]?, phases: [Phase]?, events: [Event]?) throws -> Calendar {
        if school == nil && rooms == nil && phases == nil {
            throw CreationError.TargetNotFound
        }
        return Calendar(id: id, school: school, rooms: rooms, phases: phases, events: events)
    }
}
