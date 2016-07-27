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
    
    private var cells: [MyDayCell] = []
    
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
        scrollViewHeight.constant = leftTableView.contentSize.height
    }
    
//MARK: Table View Methods
    func reloadData() {
        self.cells = MyDayBO.getCellsForClass(0) //TODO: Insert ID
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MyDaySectionHeader(label: cells[section].title, icon: 0)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("intensityCell")!
        return cell
    }
    

}
