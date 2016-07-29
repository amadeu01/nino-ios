//
//  MyDayRow.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/27/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one My Day Row
 */

struct MyDayRow {
    
    //MARK: Attributes
    let title: String
    let type: MyDayRowType
    let strings: [String]
    //MARK: Initializer
    /**
     Initialize a My Day Cell
     
     - parameter title: cell's title
     - parameter icon:  cell's icon by index
     - parameter sections:  cell's sections by index
     
     - returns: struct VO of MyDayCell type
     */
    init(title: String, type: MyDayRowType, strings: [String]) {
        self.title = title
        self.type = type
        self.strings = strings
    }
}

