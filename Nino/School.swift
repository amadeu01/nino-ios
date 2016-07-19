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
    var cnpj: Int?
    let telephone: String
    let email: String
    var owner: Int?
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
     - parameter cnpj:       optional school's legal number
     - parameter telephone:  school's phone
     - parameter email:      school's main email
     - parameter owner:      optional id of the owner of the school
     - parameter logo:       optional school's logo
     - parameter phases:     optional list of phases
     - parameter educators:  optional list of educators
     - parameter students:   optional list of students
     - parameter menus:      optional list of menus
     - parameter activities: optional list of activities
     - parameter calendars:  optional list of calendars

     - returns: struct VO of School type
     */
    init(id: Int, name: String, address: String, cnpj: Int?, telephone: String, email: String, owner: Int?, logo: NSData?, phases: [Phase]?, educators: [Educator]?, students: [Student]?, menus: [Menu]?, activities: [Activity]?, calendars: [Calendar]?) {
        self.id = id
        self.name = name
        self.address = address
        if let legalNumber = cnpj {
            self.cnpj = legalNumber
        }
        self.email = email
        self.telephone = telephone
        if let ownerID = owner {
            self.owner = ownerID
        }
        if let picture = logo {
            self.logo = picture
        }

        if let classes = phases {
            self.phases = classes
        } else {
            self.phases = [Phase]()
        }
        if let caretakers = educators {
            self.educators = caretakers
        } else {
            self.educators = [Educator]()
        }
        if let babies = students {
            self.students = babies
        } else {
            self.students = [Student]()
        }
        if let card = menus {
            self.menus = card
        } else {
            self.menus = [Menu]()
        }
        if let exercises = activities {
            self.activities = exercises
        } else {
            self.activities = [Activity]()
        }
        if let agendas = calendars {
            self.calendars = agendas
        } else {
            self.calendars = [Calendar]()
        }
    }
}
