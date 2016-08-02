//
//  SliderCellTableViewCell.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/27/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// All information about an Item on the Slider cell, helps to delete, select and save values
private class Item {
    var image: UIImageView
    var label: UILabel
    var leadingConstraint: NSLayoutConstraint
    var value: Float = 0
    
    
    /**
     Saves information of the Item
     
     - parameter image:             The View with the image
     - parameter label:             The View with the label
     - parameter leadingConstraint: The constrain that positions this item
     
     - returns: new Item
     */
    init(image: UIImageView, label: UILabel, leadingConstraint: NSLayoutConstraint) {
        self.image = image
        self.label = label
        self.leadingConstraint = leadingConstraint
    }
}

/// A cell with a slider and an image, on the tap of the plus a new Item with the image is added and the slider changes its value 
class SliderCell: UITableViewCell {

    private var items: [Item] = []
    
    //On the change of the selected item the colors and slider value are changed
    private var selectedItem: Item? {
        willSet(newItem) {
            selectedItem?.label.textColor = UIColor.blackColor()
            newItem?.label.textColor = UIColor(colorLiteralRed: 2/255, green: 119/255, blue: 155/255, alpha: 1)
            if let sliderValue = newItem?.value {
                self.slider.value = sliderValue
            } else {
                self.slider.value = 0
            }
        }
        
    }
    var itemDescription: String?
    var generalDescription: String?
    var unit: String?
    var plusIcon: UIImageView?
    var iconName: String?
    var min: Float = 0
    var max: Float = 100
    var indexPath: NSIndexPath?
    var delegate: MyDayRowDelegate?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var availableArea: UIView!
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    
    //Space between each Item
    private var itemSpacing: CGFloat = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let view = UINib(nibName: "SliderCell", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        if let cell = view {
            self.addSubview(cell)
            cell.frame = self.bounds
        }
        
        self.containerWidth.constant = self.frame.width
    }
    
    /**
     Sets up  the cell with all information needed
     
     - parameter title:       Title of the cell
     - parameter unit:        Unit of the Item (ML, hours, etc)
     - parameter iconName:    Icon name as in the xcassets to be the icon of the Item
     - parameter sliderFloor: The lowest value of Item
     - parameter sliderCeil:  The highest value of Item
     */
    func setup (title: String, unit: String, iconName: String, sliderFloor: Float?, sliderCeil: Float?, delegate: MyDayRowDelegate, generalDescription: String, itemDescription: String, indexPath: NSIndexPath) {
        
        self.delegate = delegate
        self.indexPath = indexPath
        self.generalDescription = generalDescription
        self.itemDescription = itemDescription
        //First of all sets the min and max values, if null 0 and 100 are the default
        if let floor = sliderFloor {
            self.min = floor
        }
        if let ceil = sliderCeil {
            self.max = ceil
        }
        //Sets the color of the slider :D :D :D
        self.slider.tintColor = UIColor(colorLiteralRed: 2/255, green: 119/255, blue: 155/255, alpha: 1)
        //Sets other variables
        self.title.text = title
        self.unit = unit
        self.iconName = iconName
        
        //Cleans the superview from all children
        self.availableArea.subviews.forEach({$0.removeFromSuperview()})
        
        //Creates the plus Icon
        self.plusIcon = UIImageView(image: UIImage(named: "maizin"))

        if let icon = self.plusIcon {
            //If everything ok, adds the icon to the view and adds the tap recognizer
            self.availableArea.addSubview(icon)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.userInteractionEnabled = true
            icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addItem)))
            
            //Positions it
            icon.leadingAnchor.constraintEqualToAnchor(self.availableArea.leadingAnchor, constant: itemSpacing).active = true
            icon.heightAnchor.constraintEqualToAnchor(self.availableArea.heightAnchor, multiplier: 0.60).active = true
            icon.widthAnchor.constraintEqualToAnchor(icon.heightAnchor).active = true
            icon.topAnchor.constraintEqualToAnchor(self.availableArea.topAnchor).active = true
        }
    }
    
    /**
     Adds a new item to the list on this cell
     */
    @objc private func addItem() {
        
        //Make sure all variables are here
        guard let iconName = iconName else {
            return
        }
        guard let plus = self.plusIcon else {
            return
        }
        
        //Creates the Icon and its label
        let newIcon = UIImageView(image: UIImage(named: iconName))
        let newLabel = UILabel()
        var labelUnit = ""
        if let unit = self.unit {
            labelUnit = unit
        }
        
        //Default values for the label
        newLabel.text = "\(self.min)\n\(labelUnit)"
        newLabel.textAlignment = NSTextAlignment.Center
        newLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
        newLabel.numberOfLines = 2
        
        self.availableArea.addSubview(newIcon)
        self.availableArea.addSubview(newLabel)
        
        //Creates the delete and select gesture to be put on the Items images
        let deleteGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.removeItem(_:)))
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectItem(_:)))
        
        //Configures both views
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.userInteractionEnabled = true
        newLabel.addGestureRecognizer(deleteGesture)
        newIcon.translatesAutoresizingMaskIntoConstraints = false
        newIcon.userInteractionEnabled = true
        newIcon.addGestureRecognizer(deleteGesture)
        newIcon.addGestureRecognizer(selectGesture)
        
        //Positions the Label
        newLabel.widthAnchor.constraintEqualToAnchor(newIcon.widthAnchor).active = true
        newLabel.centerXAnchor.constraintEqualToAnchor(newIcon.centerXAnchor).active = true
        newLabel.topAnchor.constraintEqualToAnchor(newIcon.bottomAnchor).active = true
        newLabel.heightAnchor.constraintEqualToAnchor(self.availableArea.heightAnchor, multiplier: 0.4)
        
        //We save the trailing constraint of the image in order to change it later, making it possible to add other items and delete too
        let trailing = newIcon.leadingAnchor.constraintEqualToAnchor(plus.trailingAnchor, constant: self.itemSpacing)
        trailing.active = true
        
        //Positions the Icon
        newIcon.centerYAnchor.constraintEqualToAnchor(plus.centerYAnchor).active = true
        newIcon.heightAnchor.constraintEqualToAnchor(plus.heightAnchor).active = true
        newIcon.widthAnchor.constraintEqualToAnchor(plus.widthAnchor).active = true
        
        //If not the first, it means that we need to open space for this item
        if self.items.count > 0 {
            //Change the constraint, so we disable the last one and create another one with a different reference
            self.items.last?.leadingConstraint.active = false
            let newConstraint = self.items.last?.image.leadingAnchor.constraintEqualToAnchor(newIcon.trailingAnchor, constant: self.itemSpacing)
            if let constraint = newConstraint {
                //Enables and saves the new constraint
                constraint.active = true
                self.items.last?.leadingConstraint = constraint
            }
        }
        //Saves the reference to this new Item
        let newItem = Item.init(image: newIcon, label: newLabel, leadingConstraint: trailing)
        self.selectedItem = newItem
        self.items.append(newItem)
        self.containerWidth.constant = CGFloat(self.items.count + 1) * (self.itemSpacing + plus.frame.width)
        
        //Enables the slider
        self.slider.enabled = true
    }
    
    /**
     Removes an item from the list
     
     - parameter sender: The GestureRecognizer holding the view touched
     */
    @objc private func removeItem(sender: UILongPressGestureRecognizer) {
        //Without this this function is called 2 times, at began and end
        if sender.state != UIGestureRecognizerState.Began {
            return
        }
        //Checks if this item really exists
        guard let target = items.indexOf({$0.image == sender.view}) else {
            return
        }
        
        //Gets items arount this one
        var right: Item?
        let this = items[target]
        var left: Item?
        if target > 0 {
            right = items[target - 1]
        }
        if target + 1 < items.count {
            left = items[target + 1]
        }
        
        //Removes the item to be removed! Doing the job o/
        this.leadingConstraint.active = false
        this.image.removeFromSuperview()
        this.label.removeFromSuperview()
        
        //Repositions the others
        if let right = right {
            right.leadingConstraint.active = false
            if let left = left {
                let newConstraint = right.image.leadingAnchor.constraintEqualToAnchor(left.image.trailingAnchor, constant: self.itemSpacing)
                if let constraint = newConstraint {
                    constraint.active = true
                    right.leadingConstraint = constraint
                }
            } else {
                let newConstraint = right.image.leadingAnchor.constraintEqualToAnchor(plusIcon?.trailingAnchor, constant: self.itemSpacing)
                if let constraint = newConstraint {
                    constraint.active = true
                    right.leadingConstraint = constraint
                }
            }
        }
        
        //Removes from the list too
        items.removeAtIndex(target)
        if items.count == 0 {
            self.slider.enabled = false
        }
        //Changes the selected item to the one to the right of the plus icon
        self.selectedItem = items.last
        
        //Tells delegate what changed 
//        if let index = self.indexPath {
//            var description = ""
//            description += self.generalDescription!.stringByReplacingOccurrencesOfString("%", withString: "\(self.items.count)\n")
//            if (self.items.count > 0) {
//                var items = ""
//                for item in self.items {
//                    items += item.label.text!
//                }
//                description += self.itemDescription!.stringByReplacingOccurrencesOfString("%", withString: items)
//            }
//            delegate?.didChangeStatus(description, indexPath: index)
//        }
    }
    
    /**
     Change the selected item, that will be affected by the slider
     
     - parameter sender: The one touched
     */
    @objc private func selectItem(sender: UITapGestureRecognizer) {
        guard let target = items.indexOf({$0.image == sender.view}) else {
            return
        }
        self.selectedItem = items[target]
    }
    
    /**
     When the slider values change. Saves the value for the icon and changes the value being show. The show value increments 10 by 10
     
     - parameter sender: the slider
     */
    @IBAction func onSliderChange(sender: UISlider) {
        //There is no item on the list, should be disabled
        if items.count == 0 {
            sender.enabled = false
            sender.value = 0
        }
        //Gets the unit
        var labelUnit = ""
        if let unit = self.unit {
            labelUnit = unit
        }
        //Do the math and change the value
        if let item = self.selectedItem {
            item.value = sender.value
            var value = Int(sender.value * (self.max - self.min) + self.min)
            value = value - value%10
            item.label.text = "\(value)\n\(labelUnit)"
        }
    }
    
    /**
     When the editing stops we tell the delegate to update
     
     - parameter sender: The Slider
     */
    @IBAction func onSliderEditingEnd(sender: UISlider) {
//        if let index = self.indexPath {
//            var description = ""
//            description += self.generalDescription!.stringByReplacingOccurrencesOfString("%", withString: "\(self.items.count)\n")
//            if (self.items.count > 0) {
//                var items = ""
//                for item in self.items {
//                    items += item.label.text!
//                }
//                description += self.itemDescription!.stringByReplacingOccurrencesOfString("%", withString: items)
//            }
//            delegate?.didChangeStatus(description, indexPath: index)
//        }
    }

}
