//
//  MyDayBO.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/25/16.
//  Copyright © 2016 Nino. All rights reserved.
//

import UIKit

private enum State {
    case Initial
    case Complete
    case Missing
    case Empty
}

//Class to handle MyDay services
//swiftlint:disable type_body_length
class MyDayBO: NSObject {
    
    /**
     Gets the cells for the MyDay screen of a given room
     
     - parameter room: The room id
     
     - returns: lists of MyDaySection
     */
    static func getCellsForRoom(room: String, schedule: NSDictionary?) throws -> (left: [MyDaySection], right: [MyDaySection]) {
        
        let (agendaLeft, agendaRight) = AgendaMechanism.getSectionsForAgenda(0)
        do {
            let left = try self.createSections(agendaLeft, schedule: schedule)
            let right = try self.createSections(agendaRight, schedule: schedule)
            return (left, right)
        } catch let error {
            throw error
        }
    }
    
    private static func createSections(sectionsInt: [Int], schedule: NSDictionary?) throws -> [MyDaySection] {
        var sections = [MyDaySection]()
        for section in sectionsInt {
            var secDict: [String: AnyObject]?
            if let dict = schedule {
                let sections = dict["sections"] as? [[String: AnyObject]]
                if let sectionsArray = sections {
                    for sectionDict in sectionsArray {
                        if sectionDict["id"] as? Int == section {
                            secDict = sectionDict
                        }
                    }
                }
            }
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
                var rowDic: [String: AnyObject]?
                if let dict = secDict {
                    let rows = dict["rows"] as? [[String: AnyObject]]
                    if let rowsArray = rows {
                        for currentDict in rowsArray {
                            if currentDict["id"] as? Int == row {
                                rowDic = currentDict
                            }
                        }
                    }
                }
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
                var index = 0
                for cell in cells {
                    do {
                        var initialValues: [Int]?
                        if let dict = rowDic {
                            if let cellValues = dict["values"] as? [[Int]] {
                                initialValues = cellValues[index]
                            }
                        }
                        let currentCell = try self.createCell(cell, initialValues: initialValues)
                        currentCells.append(currentCell)
                    } catch let error {
                        //TODO: handle create cell error
                        throw error
                    }
                    index += 1
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
    
    private static func createCell(cell: [String: AnyObject], initialValues: [Int]?) throws -> MyDayCell {
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
            var current: Int?
            if initialValues != nil {
                current = initialValues!.count - 1
            }
            return MyDayIntensityCell(title: cellTitle, buttons: cellButtons, values: initialValues, current: current)
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
            var current: Int?
            if initialValues != nil {
                current = initialValues!.count - 1
            }
            return MyDaySliderCell(title: cellTitle, unit: cellUnity, image: cellIcon, floor: cellFloor, ceil: cellCeil, values: initialValues, current: current)
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
    
    static func updateDraft(left: [MyDaySection], right: [MyDaySection], completionHandler: (update: () throws -> Void) -> Void) throws {
        guard let student = SchoolSession.currentStudent else {
            let error = MyDayError(description: "Selecione um aluno para continuar")
            throw error
        }
        let dict = self.getDictFromAgenda(Agenda(leftSections: left, rightSections: right))
        DraftBO.shouldCreateScheduleDraft(student, date: NSDate()) { (shouldCreate) in
            do {
                let should = try shouldCreate()
                if should {
                    DraftBO.createDraft(PostTypes.Schedule.rawValue, message: "", targets: [student], metadata: dict, attachment: nil, completionHandler: { (create) in
                        do {
                            try create()
                            dispatch_async(dispatch_get_main_queue(), { 
                                completionHandler(update: { 
                                    return
                                })
                            })
                        } catch {
                            print("createDraft error")
                            //TODO: create error
                        }
                    })
                } else {
                    DraftBO.getIDForScheduleDraft(student, date: NSDate(), completionHandler: { (id) in
                        do {
                            let draftID = try id()
                            DraftBO.updateDraft(draftID, message: nil, targets: nil, metadata: dict, attachment: nil, completionHandler: { (update) in
                                do {
                                    let post = try update()
                                    dispatch_async(dispatch_get_main_queue(), {
                                        completionHandler(update: {
                                            return
                                        })
                                    })
                                } catch {
                                    print("update draft error")
                                    //TODO: update draft error
                                }
                            })
                        } catch {
                            print("get draftID error")
                            //TODO: id error
                        }
                    })
                }
            } catch {
                print("shouldCreate error")
                //TODO: should create error
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
//        resultDict["left"] = sections
//        sections.removeAll()
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
//        resultDict["right"] = sections
        resultDict["sections"] = sections
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
    
    static func shouldSendSchedule(leftSections: [MyDaySection], rightSections: [MyDaySection]) throws -> String {
        let (description, error) = self.generateDescription(leftSections, rightSections: rightSections)
        if let errDict = error {
            var desc = ""
            for key in errDict.keys {
                if errDict[key]!.count > 1 {
                    desc += "A seção " + key + " está com os campos"
                    for value in errDict[key]! {
                        desc += " \"" + value + "\","
                    }
                    desc = desc.substringToIndex(desc.endIndex.predecessor())
                    desc += " vazios."
                } else {
                    desc += "A seção " + key + " está com o campo \"" + errDict[key]!.first! + "\" vazio."
                }
                desc += "\n"
            }
            desc = desc.substringToIndex(desc.endIndex.predecessor())
            let error = MyDayError(description: desc)
            throw error
        } else {
            return description!
        }
    }
    
    static func sendSchedule(student: String, description: String, completionHandler: (send: () throws -> Void) -> Void) {
        DraftBO.getIDForScheduleDraft(student, date: NSDate()) { (id) in
            do {
                let draftID = try id()
                DraftBO.updateDraft(draftID, message: description, targets: nil, metadata: nil, attachment: nil, completionHandler: { (update) in
                    do {
                        try update()
                        DraftBO.changeDraftToPost(draftID, completionHandler: { (change) in
                            do {
                                try change()
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(send: {
                                        return
                                    })
                                })
                            } catch {
                                //TODO: handle error
                                print("change schedule to post server error")
                            }
                        })
                    } catch {
                        //TODO: handle error
                        print("updte draft error")
                    }
                })
            } catch {
                //TODO: handle error
                print("get id for schedule error")
            }
        }
    }
    
    private static func generateDescription(leftSections: [MyDaySection], rightSections: [MyDaySection]) -> (description: String?, error: [String: [String]]?) {
        var scheduleDescription: String = ""
        var scheduleError = [String: [String]]()
        let agenda = [leftSections, rightSections]
        for side in agenda {
            for section in side {
                for row in section.rows {
                    //ignoring separators
                    if row.id == -1 {
                        continue
                    }
                    let (description, error) = self.rowDescription(row)
                    //complete description
                    if error == nil {
                        guard let desc = description else {
                            //unexpected case
                            return (nil, nil)
                        }
                        if !desc.isEmpty {
                            let rowDesc = desc.stringByAppendingString("\n")
                            scheduleDescription = scheduleDescription.stringByAppendingString(rowDesc)
                        }
                    }
                    //missing information
                    else {
                        if let errorDic = error {
                            scheduleError[section.title] = errorDic
                        }
                    }
                }
            }
        }
        if scheduleError.isEmpty {
            return (scheduleDescription, nil)
        } else {
            return (nil, scheduleError)
        }
    }

//swiftlint:disable cyclomatic_complexity
//swiftlint:disable function_body_length
    private static func rowDescription(row: MyDayRow) -> (description: String?, error: [String]?) {
        /// each position represents the current item for each cell
        var current = [Int]()
        var error = [String]()
        var rowState = State.Initial
        for cell in row.cells {
            current.append(0)
            var cellState = State.Initial
            for value in cell.values {
                if value == -1 {
                    error.append(cell.getTitle())
                    switch cellState {
                    case .Complete:
                        cellState = State.Missing
                    case .Initial:
                        cellState = State.Empty
                    default:
                        break
                    }
                } else {
                    switch cellState {
                    case .Initial:
                        cellState = State.Complete
                    case .Empty:
                        cellState = State.Missing
                    default:
                        break
                    }
                }
            }
            if cellState == State.Complete {
                switch rowState {
                case .Initial:
                    rowState = State.Complete
                case .Empty:
                    rowState = State.Missing
                default:
                    break
                }
            } else if cellState == State.Empty {
                switch rowState {
                case .Initial:
                    rowState = State.Empty
                case .Complete:
                    rowState = State.Missing
                default:
                    break
                }
            } else {
                switch rowState {
                case .Initial:
                    rowState = State.Missing
                case .Empty, .Complete:
                    rowState = State.Missing
                default:
                    break
                }
            }
        }
        let description = row.description
        let emptyDescription = row.emptyDescription
        if rowState == State.Empty {
            return (emptyDescription, nil)
        } else if rowState == State.Missing {
            return (nil, error)
        } else {
            //looking for text before, inside and after <each></each> tags
            let strings = description.componentsSeparatedByString("<each>")
            let before = strings.first
            var desc = ""
            let interStrings = before?.componentsSeparatedByString(" ")
            for string in interStrings! {
                if string == "" || string == " " {
                    continue
                }
                if string.containsString("%") {
                    let info = string.componentsSeparatedByString("*")
                    let number = info.first!.substringFromIndex(info.first!.endIndex.predecessor())
                    let cellIndex = Int(number)! - 1
                    var type = info[1]
                    var char: String?
                    if type.substringFromIndex(type.endIndex.predecessor()) == "." {
                        char = type.substringFromIndex(type.endIndex.predecessor())
                        type = type.substringToIndex(type.endIndex.predecessor())
                    }
                    if type == "count" {
                        desc += "\(row.cells[cellIndex].values.count)"
                    }
                    if type == "item" {
                        let cell = row.cells[cellIndex]
                        let selectedButton = current[cellIndex]
                        let cellSelected = cell.values[selectedButton]
                        
                        if let intensity = cell as? MyDayIntensityCell {
                            let cellDict = intensity.buttons
                            let cellPref = cellDict[cellSelected]["preffix"]
                            let cellSuf = cellDict[cellSelected]["suffix"]
                            let cellTitle = cellDict[cellSelected]["title"]
                            guard let preffix = cellPref else {
                                //Unexpected case
                                return (nil, nil)
                            }
                            guard let suffix = cellSuf else {
                                //Unexpected case
                                return (nil, nil)
                            }
                            guard let title = cellTitle else {
                                //Unexpected case
                                return (nil, nil)
                            }
                            desc += preffix + title + suffix
                        }
                        if let dot = char {
                            desc += dot
                        }
                        current[cellIndex] += 1
                    }
                    
                } else {
                    desc += string
                }
                desc += " "
            }
            var isSpace = desc.substringFromIndex(desc.endIndex.predecessor()) == " "
            while isSpace {
                desc.removeAtIndex(desc.endIndex.predecessor())
                isSpace = desc.substringFromIndex(desc.endIndex.predecessor()) == " "
            }
            if strings.count > 1 {
                let strings2 = strings[1].componentsSeparatedByString("</each>")
                let inside = strings2.first
                let after = strings2[1]
                desc += " "
                for _ in row.cells.first!.values {
                    let interStrings = inside?.componentsSeparatedByString(" ")
                    for string in interStrings! {
                        if string == "" || string == " " {
                            continue
                        }
                        if string.containsString("%") {
                            let info = string.componentsSeparatedByString("*")
                            let number = info.first!.substringFromIndex(info.first!.endIndex.predecessor())
                            let cellIndex = Int(number)! - 1
                            var type = info[1]
                            var char: String?
                            if type.substringFromIndex(type.endIndex.predecessor()) == "." {
                                char = type.substringFromIndex(type.endIndex.predecessor())
                                type = type.substringToIndex(type.endIndex.predecessor())
                            }
                            if type == "count" {
                                desc += "\(row.cells[cellIndex].values.count)"
                            }
                            if type == "item" {
                                let cell = row.cells[cellIndex]
                                let selectedButton = current[cellIndex]
                                let cellSelected = cell.values[selectedButton]
                                
                                if let intensity = cell as? MyDayIntensityCell {
                                    let cellDict = intensity.buttons
                                    let cellPref = cellDict[cellSelected]["preffix"]
                                    let cellSuf = cellDict[cellSelected]["suffix"]
                                    let cellTitle = cellDict[cellSelected]["title"]
                                    guard let preffix = cellPref else {
                                        //Unexpected case
                                        return (nil, nil)
                                    }
                                    guard let suffix = cellSuf else {
                                        //Unexpected case
                                        return (nil, nil)
                                    }
                                    guard let title = cellTitle else {
                                        //Unexpected case
                                        return (nil, nil)
                                    }
                                    desc += preffix + title + suffix
                                }
                                if let slider = cell as? MyDaySliderCell {
                                    let values = slider.values
                                    let unit = slider.unit
                                    desc += "\(values[current[cellIndex]])" + " " + unit
                                }
                                if let dot = char {
                                    desc += dot
                                }
                                current[cellIndex] += 1
                            }
                            
                        } else {
                            desc += string
                        }
                        desc += " "
                    }
                }
            }
            return (desc, nil)
        }
    }
    
    private func printScheduleDic(dict: NSDictionary) {
        let sections = dict["sections"] as? [[String: AnyObject]]
        for array in sections! {
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
}
