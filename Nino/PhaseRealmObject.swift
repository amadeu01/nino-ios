//
//  PhaseRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class PhaseRealmObject: Object {
    
    //School Reference
    dynamic var school: SchoolRealmObject?
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var name: String = ""
    
//MARK: Optional Attributes
    let phaseID = RealmOptional<Int>()
    let events = LinkingObjects(fromType: EventRealmObject.self, property: "phase")
    let activities = LinkingObjects(fromType: ActivityRealmObject.self, property: "phases")
    let menus = LinkingObjects(fromType: MenuRealmObject.self, property: "phases")
    let rooms = LinkingObjects(fromType: RoomRealmObject.self, property: "phase")
    let posts = LinkingObjects(fromType: PostRealmObject.self, property: "phasePost")
    let drafts = LinkingObjects(fromType: PostRealmObject.self, property: "phaseDraft")
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["phaseID"]
    }
}
