//
//  RoomRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class RoomRealmObject: Object {
    
    //Phase Reference
    dynamic var phase: PhaseRealmObject?
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var name: String = ""
    
//MARK: Optional Attributes
    let roomID = RealmOptional<Int>()
    let students = LinkingObjects(fromType: StudentRealmObject.self, property: "room")
    let events = LinkingObjects(fromType: EventRealmObject.self, property: "room")
    let educators = LinkingObjects(fromType: EducatorRealmObject.self, property: "rooms")
    let posts = LinkingObjects(fromType: PostRealmObject.self, property: "roomPost")
    let drafts = LinkingObjects(fromType: PostRealmObject.self, property: "roomDraft")
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["roomID"]
    }
}
