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
    let title: String
    let description: String
    let date: NSDate
    var confirmation: [Guardian]?

//MARK: Initializer
    /**
     Initialize one event

     - parameter id:           unique identifier
     - parameter description:  event description
     - parameter date:         event date
     - parameter title:        event title
     - parameter confirmation: optional list of

     - returns: struct VO of Event type
     */
    init(id: Int, description: String, date: NSDate, title: String, confirmation: [Guardian]?) {
        self.id = id
        self.description = description
        self.date = date
        self.title = title
        if let allowed = confirmation {
            self.confirmation = allowed
        }
    }
}
