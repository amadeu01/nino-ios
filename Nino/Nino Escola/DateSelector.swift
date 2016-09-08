//
//  DateSelector.swift
//  Nino
//
//  Created by Danilo Becke on 13/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class DateSelector: UIView {
    
//MARK: DataSource and Delegate
    var dataSource: DateSelectorDataSource? {
        didSet {
            self.setInitialDate()
            self.setMinimumValue()
        }
    }
    var delegate: DateSelectorDelegate?
    
//MARK: Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
//MARK: Variables
    /// Real date
    private var today: NSDate
    /// 1 day afte current day
    private var tomorrow: NSDate
    /// 1 day before current day
    private var yesterday: NSDate
    /// day displayed by the component
    private var currentDay: NSDate
    private let datePicker = UIDatePicker()
    override var inputView: UIView? {
        datePicker.datePickerMode = .Date
        datePicker.maximumDate = NSDate()
        datePicker.addTarget(self, action: #selector(self.handleDatePicker), forControlEvents: .ValueChanged)
        return datePicker
    }
    override var inputAccessoryView: UIView? {
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.resignFirstResponder))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolbar.items = [space, barButton]
        return toolbar
    }
    private var minimumDay: NSDate?
    
//MARK: View initialization
    required init?(coder aDecoder: NSCoder) {
        self.today = NSDate()
        self.currentDay = self.today
        self.tomorrow = self.currentDay.dateByAddingTimeInterval(60*60*24*1)
        self.yesterday = self.currentDay.dateByAddingTimeInterval(-60*60*24*1)
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed("DateSelector", owner: self, options: nil)[0] as? UIView
        if let dateSelctor = view {
            self.addSubview(dateSelctor)
            dateSelctor.frame = self.bounds
        }
        self.setLabels()
        self.checkDate()
    }
    
//MARK: DataSource updates
    private func setInitialDate() {
        let date = dataSource?.setInitialDate?()
        if let newDate = date {
            self.changeDate(newDate)
        }
    }
    
    @objc private func setMinimumValue() {
        let date = dataSource?.setMinimumDate()
        self.datePicker.minimumDate = date
        self.minimumDay = date
        self.checkDate()
    }

//MARK: Button Actions
    @IBAction func didTapDateAction(sender: UITapGestureRecognizer) {
        self.datePicker.date = self.currentDay
        self.becomeFirstResponder()
    }
    
    @IBAction func didTapRightAction(sender: UIButton) {
        self.changeDate(self.tomorrow)
    }
    
    @IBAction func didTapLeftAction(sender: UIButton) {
        self.changeDate(self.yesterday)
    }
    
//MARK: Internal methods
    private func setLabels() {
        let date = self.currentDay
        let formatter = NSDateFormatter()
        let months = formatter.standaloneMonthSymbols
        let day = NSCalendar.currentCalendar().component(.Day, fromDate: date)
        let month = NSCalendar.currentCalendar().component(.Month, fromDate: date)
        let year = NSCalendar.currentCalendar().component(.Year, fromDate: date)
        let monthString = months[month-1]
        self.dayLabel.text = String(day)
        self.monthLabel.text = monthString
        self.yearLabel.text = String(year)
        self.delegate?.dateDidChange(self.currentDay)
    }
    
    private func checkDate() {
        let order = NSCalendar.currentCalendar().compareDate(self.tomorrow, toDate: self.today, toUnitGranularity: .Day)
        self.checkOrder(order, righButton: true)
        if let minimun = self.minimumDay {
            let order2 = NSCalendar.currentCalendar().compareDate(minimun, toDate: self.yesterday, toUnitGranularity: .Day)
            self.checkOrder(order2, righButton: false)
        }
    }
    
    private func checkOrder(order: NSComparisonResult, righButton: Bool) {
        if order == NSComparisonResult.OrderedDescending {
            if righButton {
                self.rightButton.enabled = false
                self.rightButton.alpha = 0.4
            } else {
                self.leftButton.enabled = false
                self.leftButton.alpha = 0.4
            }
            //checks if the date selected by datePicker is earlier in time than today
            let newOrder = NSCalendar.currentCalendar().compareDate(self.currentDay, toDate: self.today, toUnitGranularity: .Day)
            if newOrder == NSComparisonResult.OrderedDescending {
                self.changeDate(self.today)
            }
        } else {
            if righButton {
                self.rightButton.enabled = true
                self.rightButton.alpha = 1
            } else {
                self.leftButton.enabled = true
                self.leftButton.alpha = 1
            }
        }
    }
    
    private func setTomorrow() {
        self.tomorrow = self.currentDay.dateByAddingTimeInterval(60*60*24*1)
    }
    
    private func setYesterday() {
        self.yesterday = self.currentDay.dateByAddingTimeInterval(-60*60*24*1)
    }

    @objc private func handleDatePicker() {
        self.changeDate(self.datePicker.date)
    }
    
    private func changeDate(newDate: NSDate) {
        self.currentDay = newDate
        self.setYesterday()
        self.setTomorrow()
        self.setLabels()
        self.checkDate()
    }

//MARK: UIResponder methods
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
}
//MARK: Delegate and DataSource
/**
 *  Delegate to notify when the user changes the date
 */
protocol DateSelectorDelegate {
    /**
     Delegate function called when the user sets one date
     
     - parameter date: new date
     */
    func dateDidChange(date: NSDate)
}

/**
 *  DataSource to set the initial date
 */
@objc protocol DateSelectorDataSource {
    /**
     DataSource function to set the initial date
     
     - returns: initial date
     */
    optional func setInitialDate() -> NSDate
    
    /**
     Data source function which sets the inferior bound for the datepicker
     
     - returns: inferior bound
     */
    func setMinimumDate() -> NSDate
}
