//
//  MyDayCell.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/25/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one My Day Cell
 */

struct MyDayCell {
    
    //MARK: Attributes
    let title: String
    let icon: MyDaySectionIcon
    let sections: [MyDayRow]
    let height: CGFloat
    
    //MARK: Initializer
    /**
     Initialize a My Day Cell
     
     - parameter title: cell's title
     - parameter icon:  cell's icon by index
     - parameter sections:  cell's sections by index
     
     - returns: struct VO of MyDayCell type
     */
    init(title: String, icon: MyDaySectionIcon, sections: [MyDayRow]) {
        self.title = title
        self.height = 40
        self.icon = icon
        self.sections = sections
    }
}
