//
//  ActivityRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class ActivityRealmObject: Object {
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var name: String = ""
    
//MARK: Optional Attributes
    let activityID = RealmOptional<Int>()
    dynamic var information: String? = nil

//MARK: Activity target
    dynamic var school: SchoolRealmObject?
    let phases = List<PhaseRealmObject>()
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["activityID"]
    }
}
