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
    let id: String
    var phaseID: Int?
    let name: String

//MARK: Initializer
    /**
     Initialize one phase

     - parameter phaseID:    server unique identifier
     - parameter name:       phase's name

     - returns: struct VO of Phase type
     */
    init(phaseID: Int?, name: String) {
        self.id = NSUUID().UUIDString
        self.name = name
        if let phID = phaseID {
            self.phaseID = phID
        }
    }
}
