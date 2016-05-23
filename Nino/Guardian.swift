//
//  Guardian.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one Guardian
 */
struct Guardian {

//MARK: Attributes
    let id: Int
    let name: String
    let surname: String
    var students: [Student]?

//MARK: Initializer
    /**
     Initialize one guardian

     - parameter id:       unique identifier
     - parameter name:     guardian's name
     - parameter surname:  guardian's surname
     - parameter students: optional list of students

     - returns: struct VO of Guardian type
     */
    init(id: Int, name: String, surname: String, students: [Student]?) {
        self.id = id
        self.name = name
        self.surname = surname
        if let babies = students {
            self.students = babies
        }
    }
}
