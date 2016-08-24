//
//  MyDay.swift
//  ninoPais
//
//  Created by Amadeu Cavalcante on 14/01/2016.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class MyDay: UITableViewCell {

    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var myDayOverView: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillCellWithFeed(date: NSDate, overview: String) {
        var calendar = NSCalendar.currentCalendar()
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        formatter.doesRelativeDateFormatting = true
        self.date.text = formatter.stringFromDate(date)
        self.myDayOverView.text = overview
    }
    
}
