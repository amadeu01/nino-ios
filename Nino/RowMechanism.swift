//
//  RowMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 09/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class RowMechanism: NSObject {

    static func getRowsWithID(id: Int) -> [String: AnyObject] {
        switch id {
        case 0:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("MEAL_BREAKFAST", comment: ""), "buttons": self.food()]], "description": NSLocalizedString("DESC_BREAKFAST", comment: ""), "emptyDescription": ""]
        case 1:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("MEAL_LUNCH", comment: ""), "buttons": self.food()]], "description": NSLocalizedString("DESC_LUNCH", comment: ""), "emptyDescription": ""]
        case 2:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("MEAL_AFTERNOON_SNACK", comment: ""), "buttons": self.food()]], "description": NSLocalizedString("DESC_AFTERNOON_SNACK", comment: ""), "emptyDescription": ""]
        case 3:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("MEAL_DINNER", comment: ""), "buttons": self.food()]], "description": NSLocalizedString("DESC_DINNER", comment: ""), "emptyDescription": ""]
        case 4:
            return ["cells": [["type": CellType.Slider.rawValue, "title": NSLocalizedString("TITLE_BABY_BOTTLE", comment: ""), "floor": 0, "ceil": 200, "unity": "ml", "image": MyDaySliderIcon.BabyBottles.rawValue]], "description": NSLocalizedString("DESC_BABY_BOTTLE", comment: ""), "emptyDescription": "Hoje eu não mamei."]
        case 5:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("WHEN", comment: ""), "buttons": self.sleep()], ["type": CellType.Slider.rawValue, "title": NSLocalizedString("TITLE_BABY_SLEEP", comment: ""), "floor": 0, "ceil": 180, "unity": NSLocalizedString("UNIT_BABY_SLEEP", comment: ""), "image": MyDaySliderIcon.BabySleep.rawValue]], "description": NSLocalizedString("DESC_BABY_SLEEP", comment: ""), "emptyDescription": NSLocalizedString("EMPTY_DESC_BABY_SLEEP", comment: "")    ]
        case 6:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("TITLE_EVACUATION", comment: "") , "buttons": self.evacuation()]], "description": NSLocalizedString("DESC_EVACUATION", comment: ""), "emptyDescription": NSLocalizedString("EMPTY_DESC_EVACUATION", comment: "")]
        case 7:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("TITLE_DIAPER_CHANGE", comment: ""), "buttons": self.diaper()]], "description": NSLocalizedString("DESC_DIAPER_CHANGE", comment: ""), "emptyDescription": NSLocalizedString("EMPTY_DESC_DIAPER_CHANGE", comment: "")]
            //TODO: commentaries cell
//        case 8:
//            return
        default:
            return ["cells": [["type": CellType.Intensity.rawValue, "title": NSLocalizedString("MEAL_BREAKFAST", comment: ""), "buttons": self.food()]], "description": NSLocalizedString("DESC_BREAKFAST", comment: ""), "emptyDescription": ""]
        }
    }
    
    private static func getButton(title: String, preffix: String, suffix: String) -> [String: String] {
        return ["title": title, "preffix": preffix, "suffix": suffix]
    }
    
    private static func food() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton(NSLocalizedString("TITLE_FOOD_WELL", comment: ""), preffix: NSLocalizedString("PREFIX_FOOD_WELL", comment: ""), suffix: NSLocalizedString("SUFFIX_FOOD_WELL", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_FOOD_LITTLE", comment: ""), preffix: NSLocalizedString("PREFIX_FOOD_LITTLE", comment: ""), suffix: NSLocalizedString("SUFFIX_FOOD_LITTLE", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_FOOD_NOTHING", comment: ""), preffix: NSLocalizedString("PREFIX_FOOD_NOTHING", comment: ""), suffix: NSLocalizedString("SUFFIX_FOOD_WELL", comment: "")))
        return dict
    }
    
    private static func evacuation() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton(NSLocalizedString("TITLE_EVACUATION_NORMAL", comment: ""), preffix: NSLocalizedString("PREFIX_EVACUATION_NORMAL", comment: ""), suffix: NSLocalizedString("SUFFIX_EVACUATION_NORMAL", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_EVACUATION_DOUGHLY", comment: ""), preffix: NSLocalizedString("PREFIX_EVACUATION_DOUGHLY", comment: ""), suffix: NSLocalizedString("SUFFIX_EVACUATION_DOUGHLY", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_EVACUATION_DIARRHEA", comment: ""), preffix: NSLocalizedString("PREFIX_EVACUATION_DIARRHEA", comment: ""), suffix: NSLocalizedString("SUFFIX_EVACUATION_DIARRHEA", comment: "")))
        return dict
    }
    
    private static func sleep() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton(NSLocalizedString("TITLE_SLEEP_MORNING", comment: ""), preffix: NSLocalizedString("PREFIX_SLEEP_MORNING", comment: ""), suffix: NSLocalizedString("SUFFIX_SLEEP_MORNING", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_SLEEP_NOON", comment: ""), preffix: NSLocalizedString("PREFIX_SLEEP_NOON", comment: ""), suffix: NSLocalizedString("SUFFIX_SLEEP_NOON", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_SLEEP_AFTERNOON", comment: ""), preffix: NSLocalizedString("PREFIX_SLEEP_AFTERNOON", comment: ""), suffix: NSLocalizedString("SUFFIX_SLEEP_AFTERNOON", comment: "")))
        return dict
    }
    
    private static func diaper() -> [[String: String]] {
        var dict = [[String: String]]()
        dict.append(self.getButton(NSLocalizedString("TITLE_DIAPER_ONE", comment: ""), preffix: NSLocalizedString("PREFIX_DIAPER_ONE", comment: ""), suffix: NSLocalizedString("SUFFIX_DIAPER_ONE", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_DIAPER_TWO", comment: ""), preffix: NSLocalizedString("PREFIX_DIAPER_TWO", comment: ""), suffix: NSLocalizedString("SUFFIX_DIAPER_TWO", comment: "")))
        dict.append(self.getButton(NSLocalizedString("TITLE_DIAPER_3ORMORE", comment: ""), preffix: NSLocalizedString("PREFIX_DIAPER_3ORMORE", comment: ""), suffix: NSLocalizedString("SUFFIX_DIAPER_3ORMORE", comment: "")))
        return dict
    }
}
