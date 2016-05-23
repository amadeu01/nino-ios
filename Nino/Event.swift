//
//  Event.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one event
 */
struct Event {

//MARK: Attributes
    let id: Int
    let description: String
    let date: NSDate
    var calendar: Calendar?
    var confirmation: [Student]?

//MARK: Initializer
    /**
     Initialize one event

     - parameter id:           unique identifier
     - parameter description:  event description
     - parameter date:         event date
     - parameter calendar:     optional calendar
     - parameter confirmation: optional list of allowed students

     - returns: struct VO of Event type
     */
    init(id: Int, description: String, date: NSDate, calendar: Calendar?, confirmation: [Student]?) {
        self.id = id
        self.description = description
        self.date = date
        if let schedule = calendar {
            self.calendar = schedule
        }
        if let allowed = confirmation {
            self.confirmation = allowed
        }
    }
}
