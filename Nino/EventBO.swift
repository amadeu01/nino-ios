//
//  EventBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which handle all services of events
class EventBO: NSObject {

    /**
     Creates an event
     
     - parameter id:           unique identifier
     - parameter description:  event description
     - parameter date:         event date
     - parameter title:        event title
     - parameter confirmation: optional list of guardians which allowed the event
     
     - returns: Event VO
     */
    static func createEvent(id: Int, description: String, date: NSDate, title: String, confirmation: [Guardian]?) -> Event {
        return Event(id: id, description: description, date: date, title: title, confirmation: confirmation)
    }
}
