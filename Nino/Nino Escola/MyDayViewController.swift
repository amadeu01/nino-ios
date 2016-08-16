//
//  MyDayViewController.swift
//  Nino
//
//  Created by Danilo Becke on 13/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// MyDay View Controller, showing and communicating with the BO to save inforation about the day of the child
class MyDayViewController: UIViewController, DateSelectorDelegate, UITableViewDataSource, UITableViewDelegate, MyDayCellDelegate {

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
                sliderCell.setup(sliderVO.getTitle(), unit: sliderVO.unit, iconName: sliderVO.image.rawValue, sliderFloor: sliderVO.floor, sliderCeil: sliderVO.ceil, delegate: self, indexPath: indexPath, isLeftCell: isLeft, values: sliderVO.values, current: sliderVO.current)
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
            let newRow = MyDayRow(cells: cells, description: row.description, emptyDescription: row.emptyDescription)
            rows[rowIndex] = newRow
            let newSection = MyDaySection(title: sections[indexPath.section].title, icon: sections[indexPath.section].icon, rows: rows)
            if isLeft {
                self.leftCells[indexPath.section] = newSection
            } else {
                self.rightCells[indexPath.section] = newSection
            }
        } else {
            
        }
    }
}
