//
//  MyHygiene.swift
//  ninoEscola
//
//  Created by Carlos Eduardo Millani on 12/4/15.
//  Copyright © 2015 Alfredo Cavalcante Neto. All rights reserved.
//

import UIKit

class MyHygiene: StandardNinoCollectionViewCell {

    let circleDiameter: CGFloat = 8
    
    @IBOutlet var secOne: [UIButton]!
    var circlesOne = [UIView]()
    @IBOutlet var secTwo: [UIButton]!
    var circlesTwo = [UIView]()
    
    var selectedSecOne = 0

    override func awakeFromNib() {
        super.awakeFromNib()
//        initCircles(forSection: secOne, array: circlesOne)
//        initCircles(forSection: secTwo, array: circlesTwo)
        // Initialization code
    }
//    @IBAction func secOneAction(sender: AnyObject) {
//        let button = sender as! UIButton
//        if (button.tag == selectedSecOne){//Means we need to deselect it
//            selectedSecOne = 0
//            deselect(forSection: secOne)
//            
//        }else{
//            selectedSecOne = button.tag//Should be selected
//            changeSelected(forSection: secOne, sender: sender)
//        }
//        let myEvac = Evacuation(rawValue: selectedSecOne)
//        ScheduleServices.setHygiene(baby, evacuation: myEvac!)
//    }
//    @IBAction func secTwoAction(sender: AnyObject) {
//        changeSelected(forSection: secTwo, sender: sender)
//        let button = sender as! UIButton
//        ScheduleServices.setHygiene(self.baby, diapers: button.tag)
//    }
//    
//    override func updateWithBaby(baby: Baby){
//        self.baby = baby
//        let realmInfo = ScheduleServices.getTodaysSchedule(self.baby).hygieneData?.evacuationTemp
//        for item in secOne {
//            if (realmInfo != nil){
//            selectedSecOne = realmInfo!.rawValue
//            }
//            if(realmInfo != nil && item.tag == realmInfo!.rawValue)
//            {
//                item.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//                item.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            }
//        }
//        let diapers = ScheduleServices.getTodaysSchedule(self.baby).hygieneData?.diaperChangesTemp
//        for item in secTwo {
//            if(diapers != nil && item.tag == diapers)
//            {
//                item.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//                item.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            }
//        }
//    }
//    
//    func changeSelected(forSection section : [UIButton], sender: AnyObject)
//    {
//        let button = sender as! UIButton
//        button.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//        button.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//        
//        for item in section
//        {
//            if (item != button)
//            {
//                item.subviews[0].backgroundColor = UIColor(white: 0, alpha: 100)
//                item.setTitleColor(UIColor(white: 0, alpha: 100), forState: UIControlState.Normal)
//            }
//        }
//    }
//    
//    func deselect(forSection section : [UIButton])
//    {
//        for item in section
//        {
//                item.subviews[0].backgroundColor = UIColor(white: 0, alpha: 100)
//                item.setTitleColor(UIColor(white: 0, alpha: 100), forState: UIControlState.Normal)
//        }
//    }
//    
//    func initCircles(forSection section : [UIButton], var array: [UIView])
//    {
//        for item in section
//        {
//            let circle = UIView.init(frame: CGRectMake(0, 0, circleDiameter, circleDiameter))
//            circle.layer.cornerRadius = circle.layer.frame.width/2
//            circle.backgroundColor = UIColor(white: 0, alpha: 100)
//            circle.frame.origin = CGPoint(x: -circleDiameter - 2, y: item.size.height/2 - circle.size.height/2)
//            item.addSubview(circle)
//            array.append(circle)
//        }
//    }

}
