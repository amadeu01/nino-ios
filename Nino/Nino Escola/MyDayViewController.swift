//
//  MyDayViewController.swift
//  Nino
//
//  Created by Danilo Becke on 13/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class MyDayViewController: UIViewController, DateSelectorDelegate {

    @IBOutlet weak var dateSelector: DateSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        self.dateSelector.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dateDidChange(date: NSDate) {
        print(date)
    }

}
