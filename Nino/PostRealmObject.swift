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
    dynamic var message: String = ""
    dynamic var attachment: NSData? = nil
    let readGuardians = List<GuardianRealmObject>()
    dynamic var metadata: NSData? = nil
    
//MARK: Targets
    let targetsPost = List<StudentRealmObject>()
    let targetsDraft = List<StudentRealmObject>()
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["postID"]
    }
}
