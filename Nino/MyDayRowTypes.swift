//
//  MyDayRowTypes.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/27/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 Types of row for a MyDay Section
 
 - IntensityCell: A serie of buttons, only one selected at a time
 - SliderCell:    A slider with items, can add items and change its value
 - SeparatorCell: Just a line to separate things inside a sections
 */
enum MyDayRowType: String {
    case IntensityCell = "intensityCell"
    case SliderCell = "sliderCell"
    case SeparatorCell = "separatorCell"
    
    func height() -> CGFloat {
        switch self {
        case .IntensityCell:
            return 50
        case .SliderCell:
            return 150
        case .SeparatorCell:
            return 10
        }
    }
}
