//
//  Menu.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one menu
 */
struct Menu {

//MARK: Attributes
    let id: Int
    var description: String
    var school: School?
    var phase: [Phase]?

//MARK: Initializer
    /**
     Initialize one error

     - parameter id:          unique identifier
     - parameter description: menu's description
     - parameter school:      optional school
     - parameter phase:       optional list of phases

     - returns: struct VO of Menu type
     */
    init(id: Int, description: String, school: School?, phase: [Phase]?) {
        self.id = id
        self.description = description
        if let institution = school {
            self.school = institution
        }
        if let stage = phase {
            self.phase = stage
        }
    }
}
