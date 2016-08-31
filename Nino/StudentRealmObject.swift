//
//  StudentRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class StudentRealmObject: Object {

    //School Reference
    dynamic var school: SchoolRealmObject?
    //Room Reference
    dynamic var room: RoomRealmObject?
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var surname: String = ""
    dynamic var gender: Int = -1
    dynamic var birthdate: NSDate = NSDate()
    
//MARK: Optional Attributes
    let profileID = RealmOptional<Int>()
    dynamic var profilePicture: NSData? = nil
    let guardians = LinkingObjects(fromType: GuardianRealmObject.self, property: "students")
    let posts = LinkingObjects(fromType: PostRealmObject.self, property: "targetsPost")
    let drafts = LinkingObjects(fromType: PostRealmObject.self, property: "targetsDraft")
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["profileID"]
    }
}
