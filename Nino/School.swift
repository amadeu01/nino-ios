//
//  School.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one school
 */
struct School {

//MARK: Attributes
    let id: Int
    let name: String
    let address: String
    let cnpj: Int
    let telephone: Int
    let email: String
    let owner: Int
    var logo: NSData?
    var phases: [Phase]?
    var educators: [Educator]?
    var students: [Student]?
    var menus: [Menu]?
    var activities: [Activity]?
    var calendars: [Calendar]?

//MARK: Initializer
    /**
     Initialize one school

     - parameter id:         unique identifier
     - parameter name:       school's name
     - parameter address:    school's address
     - parameter cnpj:       school's legal number
     - parameter telephone:  school's phone
     - parameter email:      school's main email
     - parameter owner:      id of the owner of the school
     - parameter logo:       optional school's logo
     - parameter phases:     optional list of phases
     - parameter educators:  optional list of educators
     - parameter students:   optional list of students
     - parameter menus:      optional list of menus
     - parameter activities: optional list of activities
     - parameter calendars:  optional list of calendars

     - returns: struct VO of School type
     */
    init(id: Int, name: String, address: String, cnpj: Int, telephone: Int, email: String, owner: Int, logo: NSData?, phases: [Phase]?, educators: [Educator]?, students: [Student]?, menus: [Menu]?, activities: [Activity]?, calendars: [Calendar]?) {
        self.id = id
        self.name = name
        self.address = address
        self.cnpj = cnpj
        self.email = email
        self.telephone = telephone
        self.owner = owner
        if let picture = logo {
            self.logo = picture
        }

        if let classes = phases {
            self.phases = classes
        }
        if let caretakers = educators {
            self.educators = caretakers
        }
        if let babies = students {
            self.students = babies
        }
        if let card = menus {
            self.menus = card
        }
        if let exercises = activities {
            self.activities = exercises
        }
        if let agendas = calendars {
            self.calendars = agendas
        }
    }
}
