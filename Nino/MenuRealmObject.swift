//
//  MenuRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class MenuRealmObject: Object {
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var information: String = ""
    
//MARK: Optional Attributes
    let menuID = RealmOptional<Int>()

//MARK: Menu target
    dynamic var school: SchoolRealmObject?
    let phases = List<PhaseRealmObject>()
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["menuID"]
    }
}
