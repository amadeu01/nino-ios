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
     
     - returns: lists of MyDaySection
     */
    static func getCellsForRoom(room: String) throws -> (left: [MyDaySection], right: [MyDaySection]) {
        
        let (agendaLeft, agendaRight) = AgendaMechanism.getSectionsForAgenda(0)
        do {
            let left = try self.createSections(agendaLeft)
            let right = try self.createSections(agendaRight)
            return (left, right)
        } catch let error {
            throw error
        }
        
//        return ([alimentationSection()], [sleepSection(), hygieneSection()])
    }
    
    private static func createSections(sectionsInt: [Int]) throws -> [MyDaySection] {
        var sections = [MyDaySection]()
        for section in sectionsInt {
            let sec = SectionMechanism.getRowsForSection(section)
            let title = sec["title"] as? String
            let icon = sec["icon"] as? String
            let rows = sec["rows"] as? [Int]
            guard let sectionTitle = title else {
                //TODO: handle missing section title error
                throw ServerError.UnexpectedCase
                
            }
            guard let sectionIcon = icon else {
                //TODO: handle missing section icon error
                throw ServerError.UnexpectedCase
            }
            guard let sectionRowsInt = rows else {
                //TODO: handle missing section rows error
                throw ServerError.UnexpectedCase
            }
            guard let currentIcon = MyDaySectionIcon(rawValue: sectionIcon) else {
                //TODO: handle wrong icon error
                throw ServerError.UnexpectedCase
            }
            var sectionRows = [MyDayRow]()
            for row in sectionRowsInt {
                let currentRowDict = RowMechanism.getRowsWithID(row)
                let rowCells = currentRowDict["cells"] as? [[String: AnyObject]]
                let rowDescription = currentRowDict["description"] as? String
                let rowEmptyDescription = currentRowDict["emptyDescription"] as? String
                guard let cells = rowCells else {
                    //TODO: handle missing cells error
                    throw ServerError.UnexpectedCase
                }
                guard let description = rowDescription else {
                    //TODO: handle missing description error
                    throw ServerError.UnexpectedCase
                }
                guard let emptyDescription = rowEmptyDescription else {
                    //TODO: handle missing emptyDescription error
                    throw ServerError.UnexpectedCase
                }
                var currentCells = [MyDayCell]()
                for cell in cells {
                    do {
                        let currentCell = try self.createCell(cell)
                        currentCells.append(currentCell)
                    } catch let error {
                        //TODO: handle create cell error
                        throw error
                    }
                }
                let currentRow = MyDayRow(cells: currentCells, description: description, emptyDescription: emptyDescription)
                sectionRows.append(currentRow)
                let separatorCell = MyDaySeparatorCell()
                let separatorRow = MyDayRow(cells: [separatorCell], description: "", emptyDescription: "")
                sectionRows.append(separatorRow)
            }
            sectionRows.removeLast()
            let currentSection = MyDaySection(title: sectionTitle, icon: currentIcon, rows: sectionRows)
            sections.append(currentSection)
        }
        return sections
    }
    
    private static func createCell(cell: [String: AnyObject]) throws -> MyDayCell {
        let type = cell["type"] as? String
        let title = cell["title"] as? String
        guard let cellType = type else {
            //TODO: handle missing cell type error
            throw ServerError.UnexpectedCase
        }
        guard let cellTitle = title else {
            //TODO: handle missing cell title error
            throw ServerError.UnexpectedCase
        }
        if cellType == CellType.Intensity.rawValue {
            let buttons = cell["buttons"] as? [[String: String]]
            guard let cellButtons = buttons else {
                //TODO: handle missing cell buttons error
                throw ServerError.UnexpectedCase
            }
            return MyDayIntensityCell(title: cellTitle, buttons: cellButtons, values: [1], current: 0)
        } else if cellType == CellType.Slider.rawValue {
            let floor = cell["floor"] as? Int
            let ceil = cell["ceil"] as? Int
            let unity = cell["unity"] as? String
            let image = cell["image"] as? String
            guard let cellFloor = floor else {
                //TODO: handle missing cell floor error
                throw ServerError.UnexpectedCase
            }
            guard let cellCeil = ceil else {
                //TODO: handle missing cell ceil error
                throw ServerError.UnexpectedCase
            }
            guard let cellUnity = unity else {
                //TODO: handle missing cell unity error
                throw ServerError.UnexpectedCase
            }
            guard let cellImage = image else {
                //TODO: handle missing cell image error
                throw ServerError.UnexpectedCase
            }
            guard let cellIcon = MyDaySliderIcon(rawValue: cellImage) else {
                //TODO: handle missing icon error
                throw ServerError.UnexpectedCase
            }
            return MyDaySliderCell(title: cellTitle, unit: cellUnity, image: cellIcon, floor: cellFloor, ceil: cellCeil, values: [10, 20, 30, -1], current: 1)
        } else {
            //TODO: handle wrong cell type error
            throw ServerError.UnexpectedCase
        }
    }
    
    static func cellDidChange(value: Int, cell: MyDayCell) -> MyDayCell {
        if let intensity = cell as? MyDayIntensityCell {
            var values = intensity.values
            values[intensity.current] = value
            return MyDayIntensityCell(title: intensity.getTitle(), buttons: intensity.buttons, values: values, current: intensity.current)
        } else if let slider = cell as? MyDaySliderCell {
            var values = slider.values
            values[slider.current] = value
            return MyDaySliderCell(title: slider.getTitle(), unit: slider.unit, image: slider.image, floor: Int(slider.floor), ceil: Int(slider.ceil), values: values, current: slider.current)
        } else {
            return MyDayIntensityCell(title: "Hey", buttons: [["title": "1", "preffix": "", "suffix": ""], ["title": "2", "preffix": "", "suffix": ""]], values: nil, current: nil)
        }
    }
}
