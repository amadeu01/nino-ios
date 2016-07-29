//
//  MyDayViewController.swift
//  Nino
//
//  Created by Danilo Becke on 13/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class MyDayViewController: UIViewController, DateSelectorDelegate, DateSelectorDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dateSelector: DateSelector!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    private var leftCells: [MyDayCell] = []
    private var rightCells: [MyDayCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        self.dateSelector.delegate = self
        self.dateSelector.dataSource = self
        
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
    
    func setInitialDate() -> NSDate {
        return NSDate()
    }

//MARK: View Methods
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewHeight.constant = max(leftTableView.contentSize.height, rightTableView.contentSize.height)
    }
    
//MARK: Table View Methods
    
    func reloadData() {
        (self.leftCells, self.rightCells) = MyDayBO.getCellsForClass(0)
        
        leftTableView.reloadData()
        rightTableView.reloadData()
        
        scrollViewHeight.constant = max(leftTableView.contentSize.height, rightTableView.contentSize.height)
        //TODO: Insert class ID
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
    
    //Just an empty cell
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch tableView {
        case leftTableView:
            return leftCells[indexPath.section].sections[indexPath.row].type.height()
        case rightTableView:
            return rightCells[indexPath.section].sections[indexPath.row].type.height()
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case leftTableView:
            return leftCells[section].sections.count
        case rightTableView:
            return rightCells[section].sections.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row: MyDayRow?
        switch tableView {
        case leftTableView:
            row = leftCells[indexPath.section].sections[indexPath.row]
        case rightTableView:
            row = rightCells[indexPath.section].sections[indexPath.row]
        default:
            row = nil
        }
        
        guard let rowNow = row else {
            return tableView.dequeueReusableCellWithIdentifier("intensityCell")!
            //TODO: Handle better
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(rowNow.type.rawValue)
        
        guard let cellNow = cell else {
            return tableView.dequeueReusableCellWithIdentifier("intensityCell")!
            //TODO: Handle better
        }
        
        if let intensityCell = cellNow as? IntensityCell {
            intensityCell.setup(rowNow.title, strings: rowNow.strings)
        }
        
        if let sliderCell = cellNow as? SliderCell {
            //TODO: Check for the size of strings
            sliderCell.setup(rowNow.title, unit: rowNow.strings[0], iconName: rowNow.strings[1], sliderFloor: 0, sliderCeil: 100)
        }
        
        return cellNow
    }
    

}
