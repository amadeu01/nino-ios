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
    let id: String
    var eventID: Int?
    let title: String
    let description: String
    let date: NSDate
    var schoolID: Int?
    var phaseID: Int?
    var roomID: Int?
    var confirmedProfileIDs: [Int]?

//MARK: Initializer
    /**
     Initialize one event
     
     - parameter id:                  event ID
     - parameter eventID:             server unique identifier
     - parameter description:         event description
     - parameter date:                event date
     - parameter title:               event title
     - parameter confirmedProfileIDs: optional list of guardians which allowed the event
     - parameter schoolID:            optional schoolID target
     - parameter phaseID:             optional phaseID target
     - parameter roomID:              optional roomID target
     
     - returns: struct VO of Event type
     */
    init(id: String, eventID: Int?, description: String, date: NSDate, title: String, confirmedProfileIDs: [Int]?, schoolID: Int?, phaseID: Int?, roomID: Int?) {
        self.id = id
        self.description = description
        self.date = date
        self.title = title
        if let allowed = confirmedProfileIDs {
            self.confirmedProfileIDs = allowed
        } else {
            self.confirmedProfileIDs = [Int]()
        }
        if let evID = eventID {
            self.eventID = evID
        }
        if let scID = schoolID {
            self.schoolID = scID
        }
        if let phID = phaseID {
            self.phaseID = phID
        }
        if let roID = roomID {
            self.roomID = roID
        }
    }
}
