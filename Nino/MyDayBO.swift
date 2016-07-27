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
    static func getCellsForClass(room: Int) -> [MyDayCell] {
        return [MyDayCell(title: "One", icon: 0, sections: [1, 2, 3, 4, 5, 6]), MyDayCell(title: "Two", icon: 0, sections: [1, 2, 3, 4, 5, 6])]
    }
}
