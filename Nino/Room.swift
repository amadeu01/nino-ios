//
//  Room.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one room
 */
struct Room {

//MARK: Attributes
    let id: String
    var roomID: Int?
    let phaseID: String
    let name: String

//MARK: Initializer
    /**
     Initialize one room

     - parameter id:         room ID
     - parameter roomID:     server unique identifier
     - parameter phaseID:    room's phase
     - parameter name:       room's name

     - returns: struct VO of Room type
     */
    init(id: String, roomID: Int?, phaseID: String, name: String) {
        self.id = id
        self.phaseID = phaseID
        self.name = name
        if let rmID = roomID {
            self.roomID = rmID
        }
    }
}
