//
//  SchoolRealmObject.swift
//  Nino
//
//  Created by Danilo Becke on 20/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import RealmSwift

class SchoolRealmObject: Object {
    
//MARK: Required Attributes
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var address: String = ""
    dynamic var telephone: String = ""
    dynamic var email: String = ""
    
//MARK: Optional Attributes
    let schoolID = RealmOptional<Int>()
    dynamic var legalNumber: String? = nil
    let ownerID = RealmOptional<Int>()
    dynamic var logo: NSData? = nil
    let phases = LinkingObjects(fromType: PhaseRealmObject.self, property: "school")
    let educators = LinkingObjects(fromType: EducatorRealmObject.self, property: "school")
    let students = LinkingObjects(fromType: StudentRealmObject.self, property: "school")
    let menus = LinkingObjects(fromType: MenuRealmObject.self, property: "school")
    let activities = LinkingObjects(fromType: ActivityRealmObject.self, property: "school")
    let events = LinkingObjects(fromType: EventRealmObject.self, property: "school")
    
//MARK: Methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["schoolID"]
    }
}
