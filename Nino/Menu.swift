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
    let id: String
    var menuID: Int?
    let description: String
    var schoolID: Int?
    var phasesID: [Int]?

//MARK: Initializer
    /**
     Initialize one menu

     - parameter id:            menu ID
     - parameter menuID:         server unique identifier
     - parameter description: menu's description
     - parameter schoolID:      optional school
     - parameter phasesID:       optional list of phases

     - returns: struct VO of Menu type
     */
    init(id: String, menuID: Int?, description: String, schoolID: Int?, phasesID: [Int]?) {
        self.id = id
        self.description = description
        if let mnID = menuID {
            self.menuID = mnID
        }
        if let institution = schoolID {
            self.schoolID = institution
        }
        if let stage = phasesID {
            self.phasesID = stage
        }
    }
}
