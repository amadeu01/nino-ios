//
//  EventRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class EventRealmObject: Object {
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var information: String = ""
    dynamic var title: String = ""
    dynamic var date: NSDate = NSDate()
    
//MARK: Optional Attributes
    let eventID = RealmOptional<Int>()
    let confirmedGuardians = List<GuardianRealmObject>()
    
//MARK: Event target
    dynamic var school: SchoolRealmObject?
    dynamic var phase: PhaseRealmObject?
    dynamic var room: RoomRealmObject?
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["eventID", "date"]
    }
}
