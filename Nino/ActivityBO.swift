//
//  ActivityBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which handle all services of activities
class ActivityBO: NSObject {

    /**
     Creates an activity
     
     - parameter id:          unique identifier
     - parameter name:        activity name
     - parameter school:      activity school
     - parameter description: optional description
     - parameter phases:      optional list of phases
     
     - returns: Activity VO
     */
    static func createActivity(id: Int, name: String, school: School, description: String?, phases: [Phase]?) -> Activity {
        return Activity(id: StringsMechanisms.generateID(), activityID: id, name: name, school: school, description: description, phasesID: nil)
    }
}
