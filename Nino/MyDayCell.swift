//
//  MyDayCell.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/27/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

protocol MyDayCell {
    var values: [Int] {get}
    var current: Int {get}
    func getTitle() -> String
    func getHeight() -> CGFloat
    func getCellIdentifier() -> String
    func isEqualTo(rhs: MyDayCell) -> Bool
}

protocol MyDayCellDelegate {
    func didChangeStatus(value: Int, indexPath: NSIndexPath, isLeftCell: Bool)
}

protocol MyDaySliderCellDelegate {
    func shouldAddItem(indexPath: NSIndexPath, isLeftCell: Bool)
    func changeSelected(toValue: Int, indexPath: NSIndexPath, isLeftCell: Bool)
    func shouldDeleteItem(target: Int, indexPath: NSIndexPath, isLeftCell: Bool)
    func deleteItem(item: Int, indexPath: NSIndexPath, isLeftCell: Bool)
}

import Foundation

/**
 *  VOs representing My Day Rows
 */

struct MyDayIntensityCell: MyDayCell {
    
    //MARK: Attributes
    private let title: String
    let buttons: [[String: String]]
    let values: [Int]
    let current: Int
    
    init(title: String, buttons: [[String: String]], values: [Int]?, current: Int?) {
        self.title = title
        self.buttons = buttons
        if let array = values {
            self.values = array
        } else {
            self.values = [-1]
        }
        if let value = current {
            self.current = value
        } else {
            self.current = 0
        }
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
    
    func isEqualTo(rhs: MyDayCell) -> Bool {
        if let cell = rhs as? MyDayIntensityCell {
            return self.title == cell.getTitle() && self.buttons == cell.buttons
        } else {
            return false
        }
    }
}

struct MyDaySliderCell: MyDayCell {
    private let title: String
    let floor: Float
    let ceil: Float
    let image: MyDaySliderIcon
    let unit: String
    let values: [Int]
    let current: Int
    
    init(title: String, unit: String, image: MyDaySliderIcon, floor: Int, ceil: Int, values: [Int]?, current: Int?) {
        self.unit = unit
        self.title = title
        self.floor = Float(floor)
        self.ceil = Float(ceil)
        self.image = image
        if let array = values {
            self.values = array
        } else {
            self.values = [-1]
        }
        if let value = current {
            self.current = value
        } else {
            self.current = 0
        }
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
    
    func isEqualTo(rhs: MyDayCell) -> Bool {
        if let cell = rhs as? MyDaySliderCell {
            return self.title == cell.getTitle() && self.unit == cell.unit && self.ceil == cell.ceil && self.floor == cell.floor
        } else {
            return false
        }
    }
}

struct MyDaySeparatorCell: MyDayCell {
    
    let values = [Int]()
    let current = -1
    
    func getTitle() -> String {
        return ""
    }
    
    func getHeight() -> CGFloat {
        return 10
    }
    
    func getCellIdentifier() -> String {
        return "separatorCell"
    }
    
    func isEqualTo(rhs: MyDayCell) -> Bool {
        return false
    }
}
