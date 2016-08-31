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
    let menuID: Int?
    let description: String
    let schoolID: Int?
    let phasesID: [Int]?

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
        self.menuID = menuID
        self.schoolID = schoolID
        self.phasesID = phasesID
    }
}
