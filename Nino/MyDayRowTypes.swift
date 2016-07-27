//
//  MyDayRowTypes.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/27/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

enum MyDayRowType: String {
    case IntensityCell = "intensityCell"
    case BottleCell = "bottleCell"
    case SleepCell = "sleepCell"
    
    func height() -> CGFloat {
        switch self {
        case .IntensityCell:
            return 50
        case .BottleCell:
            return 50
        case .SleepCell:
            return 50
        }
    }
}