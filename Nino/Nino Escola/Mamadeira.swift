//
//  Mamadeira.swift
//  teste
//
//  Created by Amadeu Cavalcante on 08/02/2016.
//  Copyright © 2016 Nino. All rights reserved.
//

import UIKit

class Mamadeira: UIView {
    
    //Delegate
    weak var delegate: MamadeiraDelegate?
    //Data Source
    weak var dataSource: MamadeiraDataSource?
    //Bottles
    internal var vectorOfbottles: [UIImageView]!
    internal var vectorOfLabels: [UILabel]!
    internal var vectorOfValues: [Int]!
    internal var actualBottle: UIImageView!
    internal var actualQuantityLabel: UILabel!
    internal var actualValue: Int!
    internal var bottlesML: [String]!
    //Max of Bottles
    internal var maxOfBottles: Int!
    //Number of Bottles
    internal var numberOfBottles: Int!
    
    var plusButton: UIButton!
    var slider: UISlider!
    var `plusConstraint`: NSLayoutConstraint!
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.plusButton = UIButton()
        self.plusButton.translatesAutoresizingMaskIntoConstraints = false
        self.plusButton.setImage(UIImage(named: "maizin"), forState: UIControlState.Normal)
        self.plusButton.addTarget(self, action: "plusButtonWasTouched", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.plusButton)
        
        self.slider = UISlider()
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.slider.minimumValue = 0
        self.slider.maximumValue = 200
        self.slider.continuous = true
        self.slider.value = 1
        self.slider.thumbTintColor = CustomizeColor.lessStrongBackgroundNino()
        self.slider.addTarget(self, action: "sliderDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(self.slider)
        
        //Constraints
        let plusButtonConstraint = FluentConstraint(self.plusButton).top.equalTo(self).top.plus(10).activate()
        self.plusConstraint = FluentConstraint(self.plusButton).leading.equalTo(self).leading.plus(26).activate()
        let sliderConstraints = [FluentConstraint(self.slider).leading.equalTo(self).leading.plus(10).activate(),
            FluentConstraint(self.slider).trailing.equalTo(self).trailing.plus(-10).activate(),
            FluentConstraint(self.slider).bottom.equalTo(self).bottom.plus(-8).activate()]
        self.addConstraints([plusButtonConstraint, self.plusConstraint])
        self.addConstraints(sliderConstraints)
        
        self.maxOfBottles = self.dataSource?.numberMaxOfBottles()
        self.numberOfBottles = -1
        if self.vectorOfValues.count != 0 {
            self.loadBottles(self.vectorOfValues)
        } else {
        //initialize vectors
            self.vectorOfbottles = [UIImageView]()
            self.vectorOfLabels = [UILabel]()
            self.vectorOfValues = [Int]()
            self.slider.enabled = false
            self.setupBottle()
        }
    }
    
    func plusButtonWasTouched() {
        self.slider.enabled = true
        self.numberOfBottles! += 1
        addBottle(self.vectorOfbottles.last)
        self.actualQuantityLabel = self.vectorOfLabels.last
        self.actualBottle = self.vectorOfbottles.last
        self.actualValue = self.vectorOfValues.last
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.removeConstraint(self.plusConstraint)
            self.plusConstraint = FluentConstraint(self.plusButton).leading.equalTo(self.actualBottle).trailing.plus(20).activate()
            self.addConstraint(self.plusConstraint)
        })
        if self.numberOfBottles == self.maxOfBottles {
            self.plusButton.hidden = true
        }
    }
    /**
     * Setup Bottles and Labels
     *
     */
    func setupBottle() {
        
        if self.numberOfBottles == self.maxOfBottles {
            UIView.animateWithDuration(1 , animations: { () -> Void in
                self.plusButton.hidden = true
            })
        } else {
            self.plusButton.hidden = false
        }
        
        if let max = self.numberOfBottles as Int! {
            if self.numberOfBottles >= 0 {
                for index in 0...max {
                    if index == 0 {
                        UIView.animateWithDuration(2, animations: { () -> Void in
                            self.addBottle(nil)
                        })
                    } else {
                        UIView.animateWithDuration(2, animations: { () -> Void in
                            self.addBottle(self.vectorOfbottles[index-1])
                        })
                        if index == max {
                            self.actualBottle = self.vectorOfbottles[index]
                            self.actualQuantityLabel = self.vectorOfLabels[index]
                            UIView.animateWithDuration(2, animations: { () -> Void in
                                self.removeConstraint(self.plusConstraint)
                                self.plusConstraint = FluentConstraint(self.plusButton).leading.equalTo(self.actualBottle).trailing.plus(20).activate()
                                self.addConstraint(self.plusConstraint)
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
    func addBottle(lastBootle: UIImageView?) {
        if self.vectorOfValues != nil && self.vectorOfValues.count > 0 {
            self.delegate?.mamadeiraWillBeAdded?(self.vectorOfValues)
        }
        self.slider.value = 0
        let image = UIImageView(image: UIImage(named: "mamadeira1"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIViewContentMode.ScaleAspectFit
        image.tag = self.vectorOfbottles.count
        vectorOfbottles.append(image)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .Center
        label.text = "0 ml"
        label.font = UIFont(name: "System", size: 16)
        label.tag = self.vectorOfLabels.count
        vectorOfLabels.append(label)
        let value = 0
        self.vectorOfValues.append(value)
        //TapGesture
        let tap = UILongPressGestureRecognizer(target: self, action: "bottleWasHeld:")
        
        image.userInteractionEnabled = true
        image.addGestureRecognizer(tap)
        
        self.addSubview(image)
        self.addSubview(label)
        
        let constraintAlign: [NSLayoutConstraint]!
        let newLabelConstraint: [NSLayoutConstraint]!
        
        if lastBootle != nil {
            constraintAlign = [FluentConstraint(image).centerY.equalTo(self.plusButton).centerY.plus(-5).activate(),
                FluentConstraint(image).leading.equalTo(lastBootle!).trailing.plus(26).activate()]
            newLabelConstraint = [FluentConstraint(label).centerX.equalTo(image).centerX.activate(), FluentConstraint(self.slider).top.equalTo(label).bottom.plus(6).activate()]
        } else {
            constraintAlign = [FluentConstraint(image).centerY.equalTo(self.plusButton).plus(-5).centerY.activate(),
                FluentConstraint(image).leading.equalTo(self).leading.plus(15).activate()]
            newLabelConstraint = [FluentConstraint(label).centerX.equalTo(image).centerX.activate(), FluentConstraint(self.slider).top.equalTo(label).bottom.plus(6).activate()]
        }
        
        self.delegate?.mamadeiraWasAddedAtIndex?(self.vectorOfValues.count - 1)
        
        self.addConstraints(constraintAlign)
        self.addConstraints(newLabelConstraint)
    }
    
    func bottleWasHeld(tap: UITapGestureRecognizer) {
        
        if let img = tap.view as? UIImageView {
            //img.image = UIImage(named: "sem-maozinha")
            self.delegate?.mamadeiraWasTouched(img.tag)
        
        }
    }
    
    func removeMamadeiraAtIndex(index: Int) {
        
        self.vectorOfbottles[index].removeFromSuperview()
        let mamadeira = self.vectorOfbottles.removeAtIndex(index)
        self.vectorOfLabels[index].removeFromSuperview()
        self.vectorOfLabels.removeAtIndex(index)
        let value = self.vectorOfValues.removeAtIndex(index)
        self.numberOfBottles! -= 1
        self.delegate?.mamadeiraWasDeleted?(mamadeira, value: value)
        self.refresh()
        if self.numberOfBottles < self.maxOfBottles {
            self.plusButton.hidden = false
        }
        if self.numberOfBottles == -1{
            self.slider.enabled = false
            self.slider.value = 0
        }
    }
    /***
     * Add existing bottles to view.
     * all the vectors must be filled with data
     */
    func addExistingBottles() {
        if self.vectorOfbottles.count > 0 {
            for index in 0...(self.vectorOfbottles.count - 1) {
                let image = self.vectorOfbottles[index]
                image.tag = index
                let label = self.vectorOfLabels[index]
                label.tag = index
                let value = self.vectorOfValues[index]
                self.addSubview(image)
                self.addSubview(label)
                
                let constraintAlign: [NSLayoutConstraint]!
                let newLabelConstraint: [NSLayoutConstraint]!
                
                if index != 0 {
                    constraintAlign = [FluentConstraint(image).centerY.equalTo(self.plusButton).plus(-5).centerY.activate(),
                        FluentConstraint(image).leading.equalTo(self.vectorOfbottles[index-1]).trailing.plus(26).activate()]
                    newLabelConstraint = [FluentConstraint(label).centerX.equalTo(image).centerX.activate(), FluentConstraint(self.slider).top.equalTo(label).bottom.plus(6).activate()]
                } else {
                    constraintAlign = [FluentConstraint(image).centerY.equalTo(self.plusButton).plus(-5).centerY.activate(),
                        FluentConstraint(image).leading.equalTo(self).leading.plus(15).activate()]
                    newLabelConstraint = [FluentConstraint(label).centerX.equalTo(image).centerX.activate(), FluentConstraint(self.slider).top.equalTo(label).bottom.plus(6).activate()]
                }
                
                self.addConstraints(constraintAlign)
                self.addConstraints(newLabelConstraint)
                if index == (self.vectorOfbottles.count - 1) {
                    self.actualBottle = image
                    self.actualQuantityLabel = label
                    self.actualValue = value
                    //print(value)
                    self.slider.value = Float(value)
                }
            }
        } else if self.vectorOfLabels.count == 0 {
            //do nothing
        }
        
    }
    /**
     * Refresh all bottles images and labels
     * Must use when delete any of the bottles.
     */
    func refresh() {
        for bottle in self.vectorOfbottles {
            bottle.removeFromSuperview()
        }
        for label in self.vectorOfLabels {
            label.removeFromSuperview()
        }
        self.actualBottle = nil
        self.actualQuantityLabel = nil
        self.addExistingBottles()
        if self.actualBottle != nil {
            UIView.animateWithDuration(2, animations: { () -> Void in
                self.removeConstraint(self.plusConstraint)
                self.plusConstraint = FluentConstraint(self.plusButton).leading.equalTo(self.actualBottle).trailing.plus(20).activate()
                self.addConstraint(self.plusConstraint)
            })
        } else {
            UIView.animateWithDuration(2, animations: { () -> Void in
                self.removeConstraint(self.plusConstraint)
                self.plusConstraint = FluentConstraint(self.plusButton).leading.equalTo(self).leading.plus(26).activate()
                self.addConstraint(self.plusConstraint)
            })
        }
        self.delegate?.mamadeirasWasRefreshed?(self.vectorOfValues)
    }
    
    func addBottleWithML(ml: Int) {
        if(ml == 0)
        {
            return
        }
        let image = UIImageView(image: UIImage(named: "mamadeira1"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIViewContentMode.ScaleAspectFit
        self.vectorOfbottles.append(image)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .Center
        label.text = "\(ml) ml"
        label.font = UIFont(name: "System", size: 16)
        self.vectorOfLabels.append(label)
        
        
        //TapGesture
        let tap = UILongPressGestureRecognizer(target: self, action: "bottleWasHeld:")
        
        image.userInteractionEnabled = true
        image.addGestureRecognizer(tap)
        
        if ml == 0 {
            image.image = UIImage(named: "mamadeira1")
        } else if Double(ml) < 0.4*200 {
            image.image = UIImage(named: "mamadeira2")
        } else if Double(ml) < 0.7*200 {
            image.image = UIImage(named: "mamadeira3")
        } else if Double(ml) < 0.9*200 {
            image.image = UIImage(named: "mamadeira4")
        } else {
            image.image = UIImage(named: "mamadeira5")
        }
        
        if self.numberOfBottles == self.maxOfBottles {
            self.plusButton.hidden = true
            return
        }
        
        
        return
    }
    
    func loadBottles(vectorOfValuesML: [Int]) {
        self.vectorOfbottles = [UIImageView]()
        self.vectorOfLabels = [UILabel]()
        self.numberOfBottles = vectorOfValuesML.count - 1
        for value in vectorOfValuesML {
            self.addBottleWithML(value)
        }
        self.addExistingBottles()
        
        if self.actualBottle != nil {
            UIView.animateWithDuration(2, animations: { () -> Void in
                self.removeConstraint(self.plusConstraint)
                self.plusConstraint = FluentConstraint(self.plusButton).leading.equalTo(self.actualBottle).trailing.plus(20).activate()
                self.addConstraint(self.plusConstraint)
            })
        } else {
            UIView.animateWithDuration(2, animations: { () -> Void in
                self.removeConstraint(self.plusConstraint)
                self.plusConstraint = FluentConstraint(self.plusButton).leading.equalTo(self).leading.plus(26).activate()
                self.addConstraint(self.plusConstraint)
            })
        }
        
    }
    
    func sliderDidChange(sender: UISlider) {
        var currentValue = Int(sender.value)
        //print(currentValue)
        let stepSize = 10
        currentValue = currentValue - (currentValue % stepSize)
        sender.value = Float(currentValue)
        if self.actualQuantityLabel != nil {
            self.actualQuantityLabel.text = "\(Int(currentValue)) ml"
            self.vectorOfValues[self.numberOfBottles] = Int(currentValue)
            self.delegate?.lastMamadeiraWasChanged?(self.vectorOfValues)
        }
        if actualBottle != nil {
            if sender.value == 0 {
                self.actualBottle.image = UIImage(named: "mamadeira1")
            } else if sender.value < 0.4*200 {
                self.actualBottle.image = UIImage(named: "mamadeira2")
            } else if sender.value < 0.7*200 {
                self.actualBottle.image = UIImage(named: "mamadeira3")
            } else if sender.value < 0.9*200 {
                self.actualBottle.image = UIImage(named: "mamadeira4")
            } else {
                self.actualBottle.image = UIImage(named: "mamadeira5")
            }
        }
    }
    
}

@objc protocol MamadeiraDelegate: class {
    func mamadeiraWasTouched(atIndex: Int)
    optional func mamadeiraWasDeleted(bottle: UIImageView, value: Int)
    optional func mamadeiraWasAddedAtIndex(index: Int)
    optional func mamadeiraWillBeAdded(vectorOfValues: [Int])
    optional func lastMamadeiraWasChanged(newVectorOfValues: [Int])
    optional func mamadeirasWasRefreshed(newVectorOfValues: [Int])
}

@objc protocol MamadeiraDataSource: class {
    optional func addMamadeiraAtIndex(index: Int)
    optional func deleteMamadeiraAtIndex(index: Int)
    func numberMaxOfBottles() -> Int
    /**
     * TODO 
     * For handle number of bottle
     */
    optional func numberOfMamadeiras() -> Int
}
