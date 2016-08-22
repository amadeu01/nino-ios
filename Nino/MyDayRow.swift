//
//  MyDayRow.swift
//  Nino
//
//  Created by Danilo Becke on 11/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

struct MyDayRow {
    let id: Int
    let description: String
    let emptyDescription: String
    let cells: [MyDayCell]
    
    init(id: Int, cells: [MyDayCell], description: String, emptyDescription: String) {
        self.id = id
        self.cells = cells
        self.description = description
        self.emptyDescription = emptyDescription
    }
}
