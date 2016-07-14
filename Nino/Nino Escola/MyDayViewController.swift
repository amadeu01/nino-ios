//
//  MyDayViewController.swift
//  Nino
//
//  Created by Danilo Becke on 13/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class MyDayViewController: UIViewController, DateSelectorDelegate, DateSelectorDataSource {

    @IBOutlet weak var dateSelector: DateSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        self.dateSelector.delegate = self
        self.dateSelector.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dateDidChange(date: NSDate) {
        //TODO: gets the agenda for the selected day
        print(date)
    }
    
    func setInitialDate() -> NSDate {
        return NSDate().dateByAddingTimeInterval(-60*60*24*2)
    }

}
