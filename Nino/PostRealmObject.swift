//
//  PostRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class PostRealmObject: Object {
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var type: Int = -1
    
//MARK: Optional Attributes
    let postID = RealmOptional<Int>()
    dynamic var date: NSDate? = nil
    let authorsProfile = List<EducatorRealmObject>()
    dynamic var message: String? = nil
    dynamic var attachment: NSData? = nil
    let readGuardians = List<GuardianRealmObject>()
    
//MARK: Targets
    dynamic var schoolPost: SchoolRealmObject?
    dynamic var schoolDraft: SchoolRealmObject?
    dynamic var phasePost: PhaseRealmObject?
    dynamic var phaseDraft: PhaseRealmObject?
    dynamic var roomPost: RoomRealmObject?
    dynamic var roomDraft: RoomRealmObject?
    let studentsPost = List<StudentRealmObject>()
    let studentsDraft = List<StudentRealmObject>()
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["postID"]
    }
}
