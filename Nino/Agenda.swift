//
//  Agenda.swift
//  Nino
//
//  Created by Danilo Becke on 09/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

struct Agenda {
    let left: [MyDaySection]
    let right: [MyDaySection]
    
    init(leftSections: [MyDaySection], rightSections: [MyDaySection]) {
        self.left = leftSections
        self.right = rightSections
    }
}
