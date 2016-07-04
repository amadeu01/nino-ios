//
//  SchoolMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 11/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Mechanism designed to handle all school operation
class SchoolMechanism: NSObject {

    /**
     Tries to create an school
     
     - parameter name:       school's name
     - parameter address:    school's address
     - parameter cnpj:       optional school's legal number
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
     - parameter completionHandler: completionHandler with optional userID, optional error and optional extra information about the error
     */
    static func createSchool(name: String, address: String, cnpj: Int?, telephone: String, email: String, owner: Int, logo: NSData?, phases: [Phase]?, educators: [Educator]?, students: [Student]?, menus: [Menu]?, activities: [Activity]?, calendars: [Calendar]?, completionHandler: ServerResponse) {
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            completionHandler(userID: 123, error: nil, data: nil)
        }
    }
}
