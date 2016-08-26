//
//  MyDayViewController.swift
//  Nino
//
//  Created by Danilo Becke on 13/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// MyDay View Controller, showing and communicating with the BO to save inforation about the day of the child
class MyDayViewController: UIViewController, DateSelectorDelegate, UITableViewDataSource, UITableViewDelegate, MyDayCellDelegate, MyDaySliderCellDelegate {

    @IBOutlet weak var dateSelector: DateSelector!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    private var leftCells: [MyDaySection] = []
    private var rightCells: [MyDaySection] = []

    
    var student: Student?
    
    /**
     On load sets delegates, background and reloads the data
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        self.dateSelector.delegate = self
        
        self.leftTableView.delegate = self
        self.rightTableView.delegate = self
        
        self.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
//MARK: Date Picker Methods
    func dateDidChange(date: NSDate) {
        //TODO: gets the agenda for the selected day
        print(date)
    }

//MARK: View Methods
    
    /**
     Adter layout changes the scrollViewHeight to show all information
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewHeight.constant = max(leftTableView.contentSize.height, rightTableView.contentSize.height)
    }
    
//MARK: Table View Methods
    
    /**
     Gets the info from BO and reloads the tableViews data, alse updating the size of the scrollView
     */
    func reloadData() {
//        guard let currentStudent = self.student else {
//            //TODO: handle missing student
//            return
//        }
        
        do {
            (self.leftCells, self.rightCells) = try MyDayBO.getCellsForRoom("sad"/*currentStudent.roomID*/)
            
            leftTableView.reloadData()
            rightTableView.reloadData()
            
            scrollViewHeight.constant = max(leftTableView.contentSize.height, rightTableView.contentSize.height)
            //TODO: Insert class ID

        } catch {
            //TODO: handle error
        }
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch tableView {
        case leftTableView:
            return leftCells.count
        case rightTableView:
            return rightCells.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
            case leftTableView:
                return leftCells[section].height
            case rightTableView:
                return rightCells[section].height
            default:
                return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
            case leftTableView:
                return MyDaySectionHeader(label: leftCells[section].title, icon: leftCells[section].icon)
            case rightTableView:
                return MyDaySectionHeader(label: rightCells[section].title, icon: rightCells[section].icon)
            default:
                return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
    
    //Size just to separete cells
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    //Just an empty cell to separate sections
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableView {
        case leftTableView:
            let cell = self.cellForIndexPath(indexPath, sections: self.leftCells)
            return cell.getHeight()
        case rightTableView:
            let cell = self.cellForIndexPath(indexPath, sections: self.rightCells)
            return cell.getHeight()
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case leftTableView:
            var number = 0
            for row in leftCells[section].rows {
                number += row.cells.count
            }
            return number
        case rightTableView:
            var number = 0
            for row in rightCells[section].rows {
                number += row.cells.count
            }
            return number
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MyDayCell?
        var isLeft: Bool
        switch tableView {
        case leftTableView:
            cell = self.cellForIndexPath(indexPath, sections: self.leftCells)
            isLeft = true
        case rightTableView:
            cell = self.cellForIndexPath(indexPath, sections: self.rightCells)
            isLeft = false
        default:
            cell = nil
            isLeft = true
        }
        
        guard let cellNow = cell else {
            return tableView.dequeueReusableCellWithIdentifier("intensityCell")!
            //TODO: Handle better
        }
        
        let tableCell = tableView.dequeueReusableCellWithIdentifier(cellNow.getCellIdentifier())
        
        guard let tableCellNow = tableCell else {
            return tableView.dequeueReusableCellWithIdentifier("intensityCell")!
            //TODO: Handle better
        }
        
        if let intensityCell = tableCellNow as? IntensityCell {
            if let intensityVO = cellNow as? MyDayIntensityCell {
                intensityCell.setup(intensityVO.getTitle(), buttonsStrings: intensityVO.buttons, delegate: self, indexPath: indexPath, isLeftCell: isLeft, values: intensityVO.values, current: intensityVO.current)
            }
        }
        
        if let sliderCell = tableCellNow as? SliderCell {
            if let sliderVO = cellNow as? MyDaySliderCell {
                sliderCell.setup(sliderVO.getTitle(), unit: sliderVO.unit, iconName: sliderVO.image.rawValue, sliderFloor: sliderVO.floor, sliderCeil: sliderVO.ceil, delegate: self, indexPath: indexPath, isLeftCell: isLeft, values: sliderVO.values, current: sliderVO.current, sliderDelegate: self)
            }
        }
        
        return tableCellNow
    }
    
//MARK: Cell delegate
    func didChangeStatus(value: Int, indexPath: NSIndexPath, isLeftCell: Bool) {
        var section: [MyDaySection]
        if isLeftCell {
            section = self.leftCells
        } else {
            section = self.rightCells
        }
        let cell = self.cellForIndexPath(indexPath, sections: section)
        let newCell = MyDayBO.cellDidChange(value, cell: cell)
        self.changeCellInSide(indexPath, isLeft: isLeftCell, newCell: newCell)
        MyDayBO.updateDraft("df", left: self.leftCells, right: self.rightCells) { (update) in
            
        }
    }
    
    func shouldAddItem(indexPath: NSIndexPath, isLeftCell: Bool) {
        let row = self.rowForIndexPath(indexPath, isLeft: isLeftCell)
        do {
            let row = try MyDayBO.shouldAddNewItem(row)
            self.changeRowInSide(indexPath, isLeft: isLeftCell, newRow: row)
            let tableView = isLeftCell ? self.leftTableView: self.rightTableView
            for cell in row.cells {
                let index = self.indexPathForCell(isLeftCell, cell: cell)
                let tableCell = tableView.cellForRowAtIndexPath(index)
                if let slider = tableCell as? SliderCell {
                    slider.addNewItem()
                }
                if let intensity = tableCell as? IntensityCell {
                    intensity.addItem()
                }
            }
        } catch {
            for cell in row.cells {
                for value in cell.values {
                    if value == -1 {
                        let alert = UIAlertController(title: "Item vazio", message: "Você não pode adicionar um novo item pois o campo \"\(cell.getTitle())\" está vazio.", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Entendi", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func changeSelected(toValue: Int, indexPath: NSIndexPath, isLeftCell: Bool) {
        let row = self.rowForIndexPath(indexPath, isLeft: isLeftCell)
        let tableView = isLeftCell ? self.leftTableView: self.rightTableView
        let sections = isLeftCell ? self.leftCells : self.rightCells
        for cell in row.cells {
            let index = self.indexPathForCell(isLeftCell, cell: cell)
            let tableCell = tableView.cellForRowAtIndexPath(index)
            if let intensity = tableCell as? IntensityCell {
                intensity.changeSelected(toValue)
            }
            let cellVO = self.cellForIndexPath(index, sections: sections)
            let newCell = self.changeCurrent(cellVO, current: toValue)
            self.changeCellInSide(index, isLeft: isLeftCell, newCell: newCell)
        }
    }
    
    func deleteItem(item: Int, indexPath: NSIndexPath, isLeftCell: Bool) {
        let tableView = isLeftCell ? self.leftTableView : self.rightTableView
        let row = self.rowForIndexPath(indexPath, isLeft: isLeftCell)
        let sections = isLeftCell ? self.leftCells : self.rightCells
        for cell in row.cells {
            let index = self.indexPathForCell(isLeftCell, cell: cell)
            let tableCell = tableView.cellForRowAtIndexPath(index)
            if let intensity = tableCell as? IntensityCell {
                intensity.deleteItem(item)
            }
            let cellVO = self.cellForIndexPath(index, sections: sections)
            let newCell = MyDayBO.deleteItem(item, cell: cellVO)
            self.changeCellInSide(index, isLeft: isLeftCell, newCell: newCell)
        }
    }
    
    func shouldDeleteItem(target: Int, indexPath: NSIndexPath, isLeftCell: Bool) {
        let cellVO = self.cellForIndexPath(indexPath, sections: isLeftCell ? self.leftCells : self.rightCells)
        var alert: UIAlertController
        if cellVO.values.count < 2 {
            alert = UIAlertController(title: "Item único", message: "Você não pode deletar esse item.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Entendi", style: .Default, handler: nil))
        } else {
            let deleteAction = UIAlertAction(title: "Confirmar", style: .Destructive) { (act) in
                let tableview = isLeftCell ? self.leftTableView : self.rightTableView
                let cell = tableview.cellForRowAtIndexPath(indexPath)
                if let slider = cell as? SliderCell {
                    slider.deleteItem(target)
                }
            }
            alert = DefaultAlerts.shouldDeleteAlert(deleteAction, customCancelAction: nil)
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
//MAARK: Private methods
    private func cellForIndexPath(indexPath: NSIndexPath, sections: [MyDaySection]) -> MyDayCell {
        
        var currentRow: MyDayRow?
        var sum = 0
        for row in sections[indexPath.section].rows {
            currentRow = row
            sum += currentRow!.cells.count
            if sum > indexPath.item {
                break
            }
        }
        if let row = currentRow {
            sum -= row.cells.count
            return row.cells[indexPath.item - sum]
        } else {
            return MyDayIntensityCell(title: "", buttons: [[String : String]](), values: nil, current: nil)
        }
    }
    
    private func changeCellInSide(indexPath: NSIndexPath, isLeft: Bool, newCell: MyDayCell) {
        let sections = isLeft ? self.leftCells: self.rightCells
        var rows = sections[indexPath.section].rows
        var currentRow: MyDayRow?
        var sum = 0
        var rowIndex = 0
        for row in sections[indexPath.section].rows {
            currentRow = row
            sum += currentRow!.cells.count
            if sum > indexPath.item {
                break
            }
            rowIndex += 1
        }
        if let row = currentRow {
            sum -= row.cells.count
            var cells = row.cells
            cells[indexPath.item - sum] = newCell
            let newRow = MyDayRow(id: row.id, cells: cells, description: row.description, emptyDescription: row.emptyDescription)
            rows[rowIndex] = newRow
            let newSection = MyDaySection(id: sections[indexPath.section].id, title: sections[indexPath.section].title, icon: sections[indexPath.section].icon, rows: rows)
            if isLeft {
                self.leftCells[indexPath.section] = newSection
            } else {
                self.rightCells[indexPath.section] = newSection
            }
        } else {
            
        }
    }
    
    private func rowForIndexPath(indexPath: NSIndexPath, isLeft: Bool) -> MyDayRow {
        let sections = isLeft ? self.leftCells: self.rightCells
        var currentRow: MyDayRow?
        var sum = 0
        for row in sections[indexPath.section].rows {
            currentRow = row
            sum += currentRow!.cells.count
            if sum > indexPath.item {
                break
            }
        }
        if let row = currentRow {
            return row
        } else {
            return MyDayRow(id: 0, cells: [], description: "", emptyDescription: "")
        }
    }
    
    private func changeRowInSide(indexPath: NSIndexPath, isLeft: Bool, newRow: MyDayRow) {
        let sections = isLeft ? self.leftCells: self.rightCells
        var sum = 0
        var rowIndex = 0
        for row in sections[indexPath.section].rows {
            sum += row.cells.count
            if sum > indexPath.item {
                break
            }
            rowIndex += 1
        }
        var rows = sections[indexPath.section].rows
        rows[rowIndex] = newRow
        let newSection = MyDaySection(id: sections[indexPath.section].id, title: sections[indexPath.section].title, icon: sections[indexPath.section].icon, rows: rows)
        if isLeft {
            self.leftCells[indexPath.section] = newSection
        } else {
            self.rightCells[indexPath.section] = newSection
        }
    }
    
    private func indexPathForCell(isLeft: Bool, cell: MyDayCell) -> NSIndexPath {
        let sections = isLeft ? self.leftCells : self.rightCells
        var secIndex = 0
        var itemIndex = 0
        for section in sections {
            for row in section.rows {
                for internalCell in row.cells {
                    if internalCell.isEqualTo(cell) {
                        return NSIndexPath(forItem: itemIndex, inSection: secIndex)
                    }
                    itemIndex += 1
                }
            }
            secIndex += 1
        }
        return NSIndexPath()
    }
    
    private func changeCurrent(cell: MyDayCell, current: Int) -> MyDayCell {
        if let intensity = cell as? MyDayIntensityCell {
            let newCell = MyDayIntensityCell(title: intensity.getTitle(), buttons: intensity.buttons, values: intensity.values, current: current)
            return newCell
        }
        if let slider = cell as? MyDaySliderCell {
            let newCell = MyDaySliderCell(title: slider.getTitle(), unit: slider.unit, image: slider.image, floor: Int(slider.floor), ceil: Int(slider.ceil), values: slider.values, current: current)
            return newCell
        }
        return MyDayIntensityCell(title: "Hey", buttons: [["1":"2"]], values: nil, current: nil)
    }
}
