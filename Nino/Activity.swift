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
    let id: Int
    let name: String
    let school: School
    var description: String?
    var phases: [Phase]?

//MARK: Initializer
    /**
     Initialize one activity

     - parameter id:          unique identifier
     - parameter name:        activity name
     - parameter school:      activity school
     - parameter description: optional description
     - parameter phases:      optional list of phases

     - returns: struct VO of Activity type
     */
    init(id: Int, name: String, school: School, description: String?, phases: [Phase]?) {
        self.id = id
        self.name = name
        self.school = school
        if let text = description {
            self.description = text
        }
        if let classes = phases {
            self.phases = classes
        }
    }
}
