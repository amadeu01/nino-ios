//
//  PhaseBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all sevices of phases
class PhaseBO: NSObject {

    /**
     Tries to create a Phase
     
     - parameter id:         unique identifier
     - parameter school:     phase's owner
     - parameter name:       phase's name
     - parameter rooms:      optional list of rooms
     - parameter menu:       optional menu
     - parameter activities: optional list of activities
     
     - returns: Phase VO
     */
    static func createPhase(id: Int, school: School, name: String, rooms: [Room]?, menu: Menu?, activities: [Activity]?) -> Phase {
        return Phase(id: id, school: school, name: name, rooms: rooms, menu: menu, activities: activities)
    }
}
