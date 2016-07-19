//
//  MySleep.swift
//  ninoEscola
//
//  Created by Carlos Eduardo Millani on 12/3/15.
//  Copyright © 2015 Alfredo Cavalcante Neto. All rights reserved.
//

import UIKit

class MySleep: StandardNinoCollectionViewCell {
    
    let circleDiameter : CGFloat = 8
    
    @IBOutlet var secOne: [UIButton]!
    var circlesOne = [UIView]()
    var selectedTag = 0 //nil if no button is selected
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        for item in secOne
//        {
//            let circle = UIView.init(frame: CGRectMake(0, 0, circleDiameter, circleDiameter))
//            circle.layer.cornerRadius = circle.layer.frame.width/2
//            circle.backgroundColor = UIColor(white: 0, alpha: 100)
//            circle.frame.origin = CGPoint(x: -circleDiameter - 2, y: item.size.height/2 - circle.size.height/2)
//            item.addSubview(circle)
//            circlesOne.append(circle)
//        }
    }
//
//    override func updateWithBaby(baby: Baby){
//        self.baby = baby
//        let realmInfo = ScheduleServices.getTodaysSchedule(self.baby).sleepData?.qualityTemp
//        selectedTag = realmInfo!.rawValue
//        for item in secOne {
//            if(realmInfo != nil && item.tag == realmInfo!.rawValue)
//            {
//                item.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//                item.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            }
//        }
//    }
//    
//    @IBAction func secOneAction(sender: AnyObject) {
//        let button = sender as! UIButton
//        var flag = false
//        if sender.tag == selectedTag{//Means the button is already selected.
//            flag = true
//            let qualityOne = Quality(rawValue: 0)
//            ScheduleServices.setSleep(self.baby, sleep: qualityOne!)
//            selectedTag = 0
//        }else{
//            selectedTag = sender.tag
//            button.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//            button.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            let theQuality = Quality(rawValue: sender.tag)
//            ScheduleServices.setSleep(self.baby, sleep: theQuality!)
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "hh:mm"
//        }
//        for item in secOne
//        {
//            print(item.titleLabel?.text)
//            if (item != button || flag)
//            {
//                item.subviews[0].backgroundColor = UIColor(white: 0, alpha: 100)
//                item.setTitleColor(UIColor(white: 0, alpha: 100), forState: UIControlState.Normal)
//            }
//        }
//    }
}