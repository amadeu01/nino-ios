//
//  Calendar.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one calendar
 */
struct Calendar {

//MARK: Attributes
    let id: Int
    var school: School?
    var rooms: [Room]?
    var phases: [Phase]?
    var events: [Event]?

//MARK: Initializer
    /**
     Initialize one calendar

     - parameter id:     unique identifier
     - parameter school: optional school
     - parameter rooms:  optional list of rooms
     - parameter phases: optional list of phases
     - parameter events: optional list of events

     - returns: struct VO of Calendar type
     */
    init(id: Int, school: School?, rooms: [Room]?, phases: [Phase]?, events: [Event]?) {
        self.id = id
        if let institution = school {
            self.school = institution
        }
        if let places = rooms {
            self.rooms = places
        }
        if let classes = phases {
            self.phases = classes
        }
        if let episodes = events {
            self.events = episodes
        }
    }
}
