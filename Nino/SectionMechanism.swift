//
//  SectionMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 09/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class SectionMechanism: NSObject {
    static func getRowsForSection(id: Int) -> [String: AnyObject] {
        switch id {
        case 0:
            return ["title": NSLocalizedString("MY_FOOD", comment: ""), "icon": MyDaySectionIcon.Food.rawValue, "rows": getAlimentation()]
        case 1:
            return ["title": NSLocalizedString("MY_SLEEP", comment: ""), "rows": self.getSleep(), "icon": MyDaySectionIcon.Sleep.rawValue]
        case 2:
            return ["title": NSLocalizedString("MY_HYGIENE", comment: ""), "rows": self.getHygiene(), "icon": MyDaySectionIcon.Hygiene.rawValue]
        case 3:
            return ["title": "Minha Alimentação", "icon": MyDaySectionIcon.Food.rawValue, "rows": getPreSchoolFood()]
//        case 4:
//            return ["title": "Minha Alimentação", "icon": MyDaySectionIcon.Food.rawValue, "rows": getCommentaries()]
        default:
            return ["title": NSLocalizedString("MY_FOOD", comment: ""), "icon": MyDaySectionIcon.Food.rawValue, "rows": self.getAlimentation()]
        }
    }
    
    private static func getAlimentation() -> [Int] {
        return [0, 1, 2, 3, 4]
    }
    
    private static func getSleep() -> [Int] {
        return [5]
    }
    
    private static func getHygiene() -> [Int] {
        return [6, 7]
    }
    
//    private static func getCommentaries() -> [Int] {
//        return [8]
//    }
    
    private static func getPreSchoolFood() -> [Int] {
        return [0, 1, 2, 3]
    }
}
