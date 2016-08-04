//
//  Activity.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one activity
 */
struct Activity {

//MARK: Attributes
    let id: String
    var activityID: Int?
    let name: String
    let school: School
    var description: String?
    var phasesID: [Int]?

//MARK: Initializer
    /**
     Initialize one activity

     - parameter id:          activity ID
     - parameter activityID:  server unique identifier
     - parameter name:        activity name
     - parameter school:      activity school id
     - parameter description: optional description
     - parameter phasesID:    optional list of phases ids

     - returns: struct VO of Activity type
     */
    init(id: String, activityID: Int?, name: String, school: School, description: String?, phasesID: [Int]?) {
        self.id = id
        self.name = name
        self.school = school
        if let text = description {
            self.description = text
        }
        if let classes = phasesID {
            self.phasesID = classes
        }
        if let actID = activityID {
            self.activityID = actID
        }
    }
}
