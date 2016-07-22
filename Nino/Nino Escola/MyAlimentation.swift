//
//  MyAlimentation.swift
//  ninoEscola
//
//  Created by Carlos Eduardo Millani on 12/4/15.
//  Copyright © 2015 Alfredo Cavalcante Neto. All rights reserved.
//

import UIKit

class MyAlimentation: StandardNinoCollectionViewCell {

    @IBOutlet weak var addBottleButton: UIButton!
    let circleDiameter: CGFloat = 8
    
    @IBOutlet var secOne: [UIButton]!
    var circlesOne = [UIView]()
    @IBOutlet var secTwo: [UIButton]!
    var circlesTwo = [UIView]()
    @IBOutlet var secThree: [UIButton]!
    var circlesThree = [UIView]()
    @IBOutlet var secFour: [UIButton]!
    var circlesFour = [UIView]()
    //@IBOutlet var secFive: [UIButton]!
    var circlesFive = [UIView]()
    
    @IBOutlet weak var mamadeira: Mamadeira!
    
    
    
    
    
    
    @IBOutlet weak var bottleCell: UIView!
    @IBOutlet weak var bottle: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var plusConstraint: NSLayoutConstraint!
    @IBOutlet weak var quatityConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sliderBottle: UISlider!
    @IBOutlet weak var quantityLeadingSpace: NSLayoutConstraint!
    let maxBottles = 5
    var numberOfBottles = 0
    var bottlesMl = [Int]()
    let formatter = NSDateFormatter()
    var selectedSecOne = 0
    var selectedSecTwo = 0
    var selectedSecThree = 0
    var selectedSecFour = 0
    
    
    func excludeBottle(sender: AnyObject?) {
//        self.bottlesMl.popLast()
        //TODO REMOVE ALL BOTTLES, just like when the screen loads
//        ScheduleServices.setFood(self.baby, bootles: self.bottlesMl)
//        for item in self.bottlesMl {
//            self.addBottleWithML(item)
//        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        initCircles(forSection: secOne, array: circlesOne)
//        initCircles(forSection: secTwo, array: circlesTwo)
//        initCircles(forSection: secThree, array: circlesThree)
//        initCircles(forSection: secFour, array: circlesFour)
//        formatter.dateFormat = "hh:mm"
        
    }
    
//    override func updateWithBaby(baby: Baby){
//        self.baby = baby
//        var realmInfo = ScheduleServices.getTodaysSchedule(self.baby).foodData?.breakfastTemp
//        selectedSecOne = realmInfo!.amountRaw
//        for item in secOne {
//            if(realmInfo != nil && item.tag == realmInfo!.amountRaw)
//            {
//                item.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//                item.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            }
//        }
//        realmInfo = ScheduleServices.getTodaysSchedule(self.baby).foodData?.lunchTemp
//        selectedSecTwo = realmInfo!.amountRaw
//        for item in secTwo {
//            if(realmInfo != nil && item.tag == realmInfo!.amountRaw)
//            {
//                item.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//                item.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            }
//        }
//        realmInfo = ScheduleServices.getTodaysSchedule(self.baby).foodData?.afternoonSnackTemp
//        selectedSecThree = realmInfo!.amountRaw
//        for item in secThree {
//            if(realmInfo != nil && item.tag == realmInfo!.amountRaw)
//            {
//                item.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//                item.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            }
//        }
//        realmInfo = ScheduleServices.getTodaysSchedule(self.baby).foodData?.dinnerTemp
//        selectedSecFour = realmInfo!.amountRaw
//        for item in secFour {
//            if(realmInfo != nil && item.tag == realmInfo!.amountRaw)
//            {
//                item.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//                item.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//            }
//        }
//        let bottles = ScheduleServices.getTodaysSchedule(self.baby).foodData?.babyBottlesTemp
//        if(bottles != nil && self.bottlesMl.isEmpty)
//        {
//            self.bottlesMl.removeAll()
//            for bottle in bottles! {
//                print(bottle.description)
//                self.bottlesMl.append(bottle.integer)
//            }
//            self.mamadeira.vectorOfValues = self.bottlesMl
//            
//        }
//    }
//    
//    @IBAction func secOneAction(sender: AnyObject) {
//        let button = sender as! UIButton
//        if (selectedSecOne == button.tag){//Button should be deselected
//            selectedSecOne = 0
//            unselect(forSection: secOne)
//            //Deselect all buttons in section
//        }else{
//        selectedSecOne = button.tag
//        changeSelected(forSection: secOne, sender: sender)
//        }
//        let myBF = Amount(rawValue: selectedSecOne)
//        ScheduleServices.setFood(self.baby, breakfast: myBF!)
//        
//    }
//    @IBAction func secTwoAction(sender: AnyObject) {
//        let button = sender as! UIButton
//        if (selectedSecTwo == button.tag){//Button should be deselected
//            selectedSecTwo = 0
//            unselect(forSection: secTwo)
//            //Deselect all buttons in section
//        }else{
//            selectedSecTwo = button.tag
//            changeSelected(forSection: secTwo, sender: sender)
//        }
//        let myLu = Amount(rawValue: selectedSecTwo)
//        ScheduleServices.setFood(self.baby, lunch: myLu!)
//        
//    }
//    @IBAction func secThreeAction(sender: AnyObject) {
//        let button = sender as! UIButton
//        if (selectedSecThree == button.tag){//Button should be deselected
//            selectedSecThree = 0
//            unselect(forSection: secThree)
//            //Deselect all buttons in section
//        }else{
//            selectedSecThree = button.tag
//            changeSelected(forSection: secThree, sender: sender)
//        }
//        let mySn = Amount(rawValue: selectedSecThree)
//        ScheduleServices.setFood(self.baby, snack: mySn!)
//        
//    }
//    @IBAction func secFourAction(sender: AnyObject) {
//        let button = sender as! UIButton
//        if (selectedSecFour == button.tag){//Button should be deselected
//            selectedSecFour = 0
//            unselect(forSection: secFour)
//            //Deselect all buttons in section
//            
//        }else{
//            selectedSecFour = button.tag
//            changeSelected(forSection: secFour, sender: sender)
//        }
//        let myDi = Amount(rawValue: selectedSecFour)
//        ScheduleServices.setFood(self.baby, dinner: myDi!)
//        
//    }
//    /*@IBAction func secFiveAction(sender: AnyObject) {
//        changeSelected(forSection: secFive, sender: sender)
//    }*/
//    
//    func changeSelected(forSection section : [UIButton], sender: AnyObject)
//    {
//        let button = sender as! UIButton
//        button.setTitleColor(CustomizeColor.lessStrongBackgroundNino(), forState: UIControlState.Normal)
//        button.subviews[0].backgroundColor = CustomizeColor.lessStrongBackgroundNino()
//        for item in section
//        {
//            if (item != button)
//            {
//                item.subviews[0].backgroundColor = UIColor(white: 0, alpha: 100)
//                item.setTitleColor(UIColor(white: 0, alpha: 100), forState: UIControlState.Normal)
//            }
//        }
//    }
//    func unselect(forSection section: [UIButton]){
//        for item in section
//        {
//            
//            
//                item.subviews[0].backgroundColor = UIColor(white: 0, alpha: 100)
//                item.setTitleColor(UIColor(white: 0, alpha: 100), forState: UIControlState.Normal)
//            
//        }
//    }
//    
//    
//    func initCircles(forSection section : [UIButton], var array: [UIView])
//    {
//        for item in section
//        {
//            let circle = UIView.init(frame: CGRectMake(0, 0, circleDiameter, circleDiameter))
//            circle.layer.cornerRadius = circle.layer.frame.width/2
//            circle.backgroundColor = UIColor(white: 0, alpha: 100)
//            circle.frame.origin = CGPoint(x: -circleDiameter - 2, y: item.frame.height/2 - circle.frame.height/2)
//            item.addSubview(circle)
//            array.append(circle)
//        }
//    }

    
    
}
