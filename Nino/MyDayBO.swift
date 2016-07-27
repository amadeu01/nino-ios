//
//  MyDayBO.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/25/16.
//  Copyright © 2016 Nino. All rights reserved.
//

import UIKit

//Class to handle MyDay services
class MyDayBO: NSObject {
    
    /**
     Gets the cells for the MyDay screen of a given room
     
     - parameter room: The room id
     
     - returns: list of MyDayCell VOs
     */
    static func getCellsForClass(room: Int) -> (left: [MyDayCell], right: [MyDayCell]) {
        //TODO: Mocked :D
        var left = [MyDayCell.init(title: "One", icon: MyDaySectionIcon.Food, sections: [MyDayRow.init(title: "OneDotFive", type: MyDayRowType.IntensityCell)])]
        left.append(MyDayCell.init(title: "LeftTwo", icon: MyDaySectionIcon.Food, sections: [MyDayRow.init(title: "Uno", type: MyDayRowType.IntensityCell), MyDayRow.init(title: "Duo", type: MyDayRowType.IntensityCell)]))
        let right = [MyDayCell.init(title: "Two", icon: MyDaySectionIcon.Food, sections: [MyDayRow.init(title: "Three", type: MyDayRowType.IntensityCell)])]
        return (left, right)
    }
}
