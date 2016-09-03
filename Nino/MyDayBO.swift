//
//  MyDayBO.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/25/16.
//  Copyright © 2016 Nino. All rights reserved.
//

import UIKit

private enum CellState {
    case Initial
    case Complete
    case Missing
    case Empty
}

private enum RowState {
    case Initial
    case Complete
    case Missing
    case Empty
}

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
                let currentRow = MyDayRow(id: row, cells: currentCells, description: description, emptyDescription: emptyDescription)
                sectionRows.append(currentRow)
                let separatorCell = MyDaySeparatorCell()
                let separatorRow = MyDayRow(id: -1, cells: [separatorCell], description: "", emptyDescription: "")
                sectionRows.append(separatorRow)
            }
            sectionRows.removeLast()
            let currentSection = MyDaySection(id: section, title: sectionTitle, icon: currentIcon, rows: sectionRows)
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
            return MyDayIntensityCell(title: cellTitle, buttons: cellButtons, values: nil, current: nil)
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
            return MyDaySliderCell(title: cellTitle, unit: cellUnity, image: cellIcon, floor: cellFloor, ceil: cellCeil, values: nil, current: nil)
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
    
    static func updateDraft(student: String, left: [MyDaySection], right: [MyDaySection], completionHandler: (update: () throws -> Void) -> Void) {
        let dict = self.getDictFromAgenda(Agenda(leftSections: left, rightSections: right))
        let leftArray = dict["left"] as? [[String: AnyObject]]
        for array in leftArray! {
            let id = array["id"] as? Int
            print("secID: \(id!)")
            let rows = array["rows"] as? [[String: AnyObject]]
            for row in rows! {
                let id = row["id"] as? Int
                print("   rowID: \(id!)")
                let cells = row["values"] as? [[Int]]
                for cell in cells! {
                    print("      cellValues: \(cell)")
                }
            }
        }
        let rightArray = dict["right"] as? [[String: AnyObject]]
        for array in rightArray! {
            let id = array["id"] as? Int
            print("secID: \(id!)")
            let rows = array["rows"] as? [[String: AnyObject]]
            for row in rows! {
                let id = row["id"] as? Int
                print("   rowID: \(id!)")
                let cells = row["values"] as? [[Int]]
                for cell in cells! {
                    print("      cellValues: \(cell)")
                }
            }
        }
    }
    
    static private func getDictFromAgenda(agenda: Agenda) -> [String: AnyObject] {
        let left = agenda.left
        let right = agenda.right
        var sections = [[String: AnyObject]]()
        var resultDict = [String: AnyObject]()
        for section in left {
            let secID = section.id
            var rows = [[String: AnyObject]]()
            for row in section.rows {
                let rowID = row.id
                if rowID == -1 {
                    continue
                }
                var cellValues = [[Int]]()
                for cell in row.cells {
                    cellValues.append(cell.values)
                }
                let dict: [String: AnyObject] = ["id": rowID, "values": cellValues]
                rows.append(dict)
            }
            let dict: [String: AnyObject] = ["id": secID, "rows": rows]
            sections.append(dict)
        }
        resultDict["left"] = sections
        sections.removeAll()
        for section in right {
            let secID = section.id
            var rows = [[String: AnyObject]]()
            for row in section.rows {
                let rowID = row.id
                if rowID == -1 {
                    continue
                }
                var cellValues = [[Int]]()
                for cell in row.cells {
                    cellValues.append(cell.values)
                }
                let dict: [String: AnyObject] = ["id": rowID, "values": cellValues]
                rows.append(dict)
            }
            let dict: [String: AnyObject] = ["id": secID, "rows": rows]
            sections.append(dict)
        }
        resultDict["right"] = sections
        return resultDict
    }
    
    static func shouldAddNewItem(row: MyDayRow) throws -> MyDayRow {
        for cell in row.cells {
            for value in cell.values {
                if value == -1 {
                    throw CreationError.EmptyField
                }
            }
        }
        var cells = [MyDayCell]()
        for cell in row.cells {
            let newCell: MyDayCell
            if let intensity = cell as? MyDayIntensityCell {
                var values = intensity.values
                values.append(-1)
                let current = intensity.current + 1
                newCell = MyDayIntensityCell(title: intensity.getTitle(), buttons: intensity.buttons, values: values, current: current)
            } else if let slider = cell as? MyDaySliderCell {
                var values = slider.values
                values.append(-1)
                let current = slider.current + 1
                newCell = MyDaySliderCell(title: slider.getTitle(), unit: slider.unit, image: slider.image, floor: Int(slider.floor), ceil: Int(slider.ceil), values: values, current: current)
            } else {
                newCell = MyDayIntensityCell(title: "Hey", buttons: [["title": "1", "preffix": "", "suffix": ""], ["title": "2", "preffix": "", "suffix": ""]], values: nil, current: nil)
            }
            cells.append(newCell)
        }
        return MyDayRow(id: row.id, cells: cells, description: row.description, emptyDescription: row.emptyDescription)
    }
    
    static func deleteItem(item: Int, cell: MyDayCell) -> MyDayCell {
        if let intensity = cell as? MyDayIntensityCell {
            var newValues = intensity.values
            newValues.removeAtIndex(item)
            let newCell = MyDayIntensityCell(title: intensity.getTitle(), buttons: intensity.buttons, values: newValues, current: newValues.count - 1)
            return newCell
        }
        if let slider = cell as? MyDaySliderCell {
            var newValues = slider.values
            newValues.removeAtIndex(item)
            let newCell = MyDaySliderCell(title: slider.getTitle(), unit: slider.unit, image: slider.image, floor: Int(slider.floor), ceil: Int(slider.ceil), values: newValues, current: newValues.count - 1)
            return newCell
        }
        return MyDayIntensityCell(title: "Hey", buttons: [["1":"2"]], values: nil, current: nil)
    }
    
    static func shouldChangeSelected(row: MyDayRow, selected: Int) -> (should: Bool, field: Int?) {
        var index = 0
        for cell in row.cells {
            if cell.values[selected] == -1 {
                return (false, index)
            }
            index += 1
        }
        return (true, nil)
    }
    
//    static func sendSchedule(leftSections: [MyDaySection], rightSections: [MyDaySection], completionHandler: (send: () throws -> Void) -> Void) throws {
//        let (description, error) = self.generateDescription(leftSections, rightSections: rightSections)
//        if let errDict = error {
//            
//        } else {
//            
//        }
//    }
    
//    private static func generateDescription(leftSections: [MyDaySection], rightSections: [MyDaySection]) -> (description: String?, error: [String: [String: Int]]?) {
//        var description: String
//        for section in leftSections {
//            for row in section.rows {
//                
//            }
//        }
//    }

//swiftlint:disable cyclomatic_complexity
    private static func rowDescription(row: MyDayRow) -> (description: String?, error: [String: [String: Int]]?) {
        /// each position represents the current item for each cell
        var current = [Int]()
        var rowState = RowState.Initial
        for cell in row.cells {
            current.append(0)
            var cellState = CellState.Initial
            for value in cell.values {
                if value == -1 {
                    switch cellState {
                    case .Complete:
                        cellState = CellState.Missing
                    case .Initial:
                        cellState = CellState.Empty
                    default:
                        break
                    }
                } else {
                    switch cellState {
                    case .Initial:
                        cellState = CellState.Complete
                    case .Empty:
                        cellState = CellState.Missing
                    default:
                        break
                    }
                }
            }
            if cellState == CellState.Complete {
                switch rowState {
                case .Initial:
                    rowState = RowState.Complete
                case .Empty:
                    rowState = RowState.Missing
                default:
                    break
                }
            } else if cellState == CellState.Empty {
                switch rowState {
                case .Initial:
                    rowState = RowState.Empty
                case .Complete:
                    rowState = RowState.Missing
                default:
                    break
                }
            } else {
                switch rowState {
                case .Initial:
                    rowState = RowState.Missing
                case .Empty, .Complete:
                    rowState = RowState.Missing
                default:
                    break
                }
            }
        }
        var description = row.description
        let emptyDescription = row.emptyDescription
        if rowState == RowState.Empty {
            print("row \(row.id) vazia")
        } else if rowState == RowState.Missing {
            print("row \(row.id) missing")
        } else {
            print("row \(row.id) completa")
        }
        return (nil, nil)
    }
}
