//
//  Educator.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one Educator
 */
struct Educator {

//MARK: Attributes
    let id: String
    var profileID: Int?
    let name: String
    let surname: String
    let gender: Gender
    let email: String
    var rooms: [String]?

//MARK: Initializer
    /**
     Initialize one educator

     - parameter id:            educator ID
     - parameter profileID:     server profile unique identifier
     - parameter name:          educator's name
     - parameter surname:       educator's surname
     - parameter gender:        educator's gender
     - parameter email:         educator's email
     - parameter rooms:         optional list of rooms ids

     - returns: struct VO of Guardian type
     */
    init(id: String, profileID: Int?, name: String, surname: String, gender: Gender, email: String, rooms: [String]?) {
        self.id = id
        self.name = name
        self.surname = surname
        self.gender = gender
        self.email = email
        if let place = rooms {
            self.rooms = place
        } else {
            self.rooms = [String]()
        }
        if let profID = profileID {
            self.profileID = profID
        }
    }
}
