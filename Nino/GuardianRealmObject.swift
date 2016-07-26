//
//  GuardianRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class GuardianRealmObject: Object {
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var surname: String = ""
    dynamic var gender: Int = -1
    dynamic var email: String = ""
    
//MARK: Optional Attributes
    let profileID = RealmOptional<Int>()
    let students = List<StudentRealmObject>()
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["profileID"]
    }
}