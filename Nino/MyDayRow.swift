//
//  MyDayRow.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/27/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

protocol MyDayRow {
    func getTitle() -> String
    func getHeight() -> CGFloat
    func getCellIdentifier() -> String
}

protocol MyDayRowDelegate {
    func didChangeStatus(status: String, indexPath: NSIndexPath)
}

import Foundation

/**
 *  VOs representing My Day Rows
 */

struct MyDayIntensityRow: MyDayRow {
    
    //MARK: Attributes
    private let title: String
    let strings: [String]
    let preDescription: String
    let emptyDescription: String
    
    init(title: String, strings: [String], description: String, emptyDescription: String) {
        self.title = title
        self.strings = strings
        self.preDescription = description
        self.emptyDescription = emptyDescription
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getHeight() -> CGFloat {
        return 50
    }
    
    func getCellIdentifier() -> String {
        return "intensityCell"
    }
}

struct MyDaySliderRow: MyDayRow {
    private let title: String
    let generalDescription: String
    let itemDescription: String
    let floor: Float
    let ceil: Float
    let image: MyDaySliderIcon
    let unit: String
    
    init(title: String, unit: String, image: MyDaySliderIcon, floor: Int, ceil: Int, generalDescription: String, itemDescription: String) {
        self.unit = unit
        self.title = title
        self.generalDescription = generalDescription
        self.itemDescription = itemDescription
        self.floor = Float(floor)
        self.ceil = Float(ceil)
        self.image = image
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getHeight() -> CGFloat {
        return 150
    }
    
    func getCellIdentifier() -> String {
        return "sliderCell"
    }
}

struct MyDaySeparatorRow: MyDayRow {
    func getTitle() -> String {
        return ""
    }
    
    func getHeight() -> CGFloat {
        return 10
    }
    
    func getCellIdentifier() -> String {
        return "separatorCell"
    }
}
