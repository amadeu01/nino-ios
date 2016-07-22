//
//  MenuBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of menus
class MenuBO: NSObject {

    /**
     Creates a menu
     
     - parameter id:          unique identifier
     - parameter description: menu's description
     - parameter school:      optional school
     - parameter phase:       optional list of phases
     
     - returns: Menu VO
     */
    static func createMenu(id: Int, description: String, school: School?, phase: [Phase]?) -> Menu {
        return Menu(menuID: id, description: description, schoolID: (school?.schoolID)!, phasesID: [(phase?.first?.phaseID)!])
    }
}
