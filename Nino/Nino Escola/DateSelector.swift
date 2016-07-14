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
    var today: NSDate
    /// 1 day afte current day
    var tomorrow: NSDate
    /// 1 day before current day
    var yesterday: NSDate
    /// day displayed by the component
    var currentDay: NSDate
    
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
        let date = dataSource?.setInitialDate()
        if let newDate = date {
            self.currentDay = newDate
            self.setTomorrow()
            self.setYesterday()
            self.setLabels()
            self.checkDate()
        }
    }

//MARK: Button Actions
    @IBAction func didTapDateAction(sender: UITapGestureRecognizer) {
    }
    
    @IBAction func didTapRightAction(sender: UIButton) {
        self.currentDay = self.tomorrow
        self.setYesterday()
        self.setTomorrow()
        self.setLabels()
        self.checkDate()
        self.delegate?.dateDidChange(self.currentDay)
    }
    
    @IBAction func didTapLeftAction(sender: UIButton) {
        self.currentDay = self.yesterday
        self.setYesterday()
        self.setTomorrow()
        self.setLabels()
        self.checkDate()
        self.delegate?.dateDidChange(self.currentDay)
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
    }
    
    private func checkDate() {
        if self.tomorrow.compare(self.today) == NSComparisonResult.OrderedDescending {
            self.rightButton.enabled = false
            self.rightButton.alpha = 0.4
        } else {
            self.rightButton.enabled = true
            self.rightButton.alpha = 1
        }
    }
    
    private func setTomorrow() {
        self.tomorrow = self.currentDay.dateByAddingTimeInterval(60*60*24*1)
    }
    
    private func setYesterday() {
        self.yesterday = self.currentDay.dateByAddingTimeInterval(-60*60*24*1)
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
protocol DateSelectorDataSource {
    /**
     DataSource function to set the initial date
     
     - returns: initial date
     */
    func setInitialDate() -> NSDate
}
