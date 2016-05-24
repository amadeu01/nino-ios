//
//  Phase.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one Phase
 */
struct Phase {

//MARK: Attributes
    let id: Int
    let school: School
    let name: String
    var rooms: [Room]?
    var menu: Menu?
    var activities: [Activity]?

//MARK: Initializer
    /**
     Initialize one phase

     - parameter id:         unique identifier
     - parameter school:     phase's owner
     - parameter name:       phase's name
     - parameter rooms:      optional list of rooms
     - parameter menu:       optional menu
     - parameter activities: optional list of activities

     - returns: struct VO of Phase type
     */
    init(id: Int, school: School, name: String, rooms: [Room]?, menu: Menu?, activities: [Activity]?) {
        self.id = id
        self.school = school
        self.name = name
        if let places = rooms {
            self.rooms = places
        }
        if let card = menu {
            self.menu = card
        }
        if let exercises = activities {
            self.activities = exercises
        }
    }
}
