//
//  SliderCellTableViewCell.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/27/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

private class Item {
    var image: UIImageView
    var label: UILabel
    var leadingConstraint: NSLayoutConstraint
    var value: Float = 0
    
    init(image: UIImageView, label: UILabel, leadingConstraint: NSLayoutConstraint) {
        self.image = image
        self.label = label
        self.leadingConstraint = leadingConstraint
    }
}

class SliderCell: UITableViewCell {

    private var items: [Item] = []
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
    var unit: String?
    var plusIcon: UIImageView?
    var iconName: String?
    var min: Float = 0
    var max: Float = 100
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var availableArea: UIView!
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    
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
    
    func setup (title: String, unit: String, iconName: String, sliderFloor: Float?, sliderCeil: Float?) {
        
        if let floor = sliderFloor {
            self.min = floor
        }
        if let ceil = sliderCeil {
            self.max = ceil
        }
        
        self.title.text = title
        self.unit = unit
        self.iconName = iconName
        
        self.availableArea.subviews.forEach({$0.removeFromSuperview()}) //Cleans the superview from all children
        self.plusIcon = UIImageView(image: UIImage(named: "maizin"))

        if let icon = self.plusIcon {
            self.availableArea.addSubview(icon)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.userInteractionEnabled = true
            icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.addItem)))
            
            icon.leadingAnchor.constraintEqualToAnchor(self.availableArea.leadingAnchor, constant: itemSpacing).active = true
            icon.heightAnchor.constraintEqualToAnchor(self.availableArea.heightAnchor, multiplier: 0.60).active = true
            icon.widthAnchor.constraintEqualToAnchor(icon.heightAnchor).active = true
            icon.topAnchor.constraintEqualToAnchor(self.availableArea.topAnchor).active = true
        }
    }
    
    @objc private func addItem() {
        guard let iconName = iconName else {
            return
        }
        guard let plus = self.plusIcon else {
            return
        }
        
        let newIcon = UIImageView(image: UIImage(named: iconName))
        let newLabel = UILabel()
        var labelUnit = ""
        if let unit = self.unit {
            labelUnit = unit
        }
        
        newLabel.text = "0\n\(labelUnit)"
        newLabel.textAlignment = NSTextAlignment.Center
        newLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
        newLabel.numberOfLines = 2
        
        self.availableArea.addSubview(newIcon)
        self.availableArea.addSubview(newLabel)
        
        let deleteGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.removeItem(_:)))
        let selectGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectItem(_:)))
        
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        newLabel.userInteractionEnabled = true
        newLabel.addGestureRecognizer(deleteGesture)
        newIcon.translatesAutoresizingMaskIntoConstraints = false
        newIcon.userInteractionEnabled = true
        newIcon.addGestureRecognizer(deleteGesture)
        newIcon.addGestureRecognizer(selectGesture)
        
        newLabel.widthAnchor.constraintEqualToAnchor(newIcon.widthAnchor).active = true
        newLabel.centerXAnchor.constraintEqualToAnchor(newIcon.centerXAnchor).active = true
        newLabel.topAnchor.constraintEqualToAnchor(newIcon.bottomAnchor).active = true
        newLabel.heightAnchor.constraintEqualToAnchor(self.availableArea.heightAnchor, multiplier: 0.4)
        
        
        let trailing = newIcon.leadingAnchor.constraintEqualToAnchor(plus.trailingAnchor, constant: self.itemSpacing)
        trailing.active = true
        
        newIcon.centerYAnchor.constraintEqualToAnchor(plus.centerYAnchor).active = true
        newIcon.heightAnchor.constraintEqualToAnchor(plus.heightAnchor).active = true
        newIcon.widthAnchor.constraintEqualToAnchor(plus.widthAnchor).active = true
        
        if self.items.count > 0 { //Means that we need to open space for this item
            self.items.last?.leadingConstraint.active = false
            let newConstraint = self.items.last?.image.leadingAnchor.constraintEqualToAnchor(newIcon.trailingAnchor, constant: self.itemSpacing)
            if let constraint = newConstraint {
                constraint.active = true
                self.items.last?.leadingConstraint = constraint
            }
            
        }
        let newItem = Item.init(image: newIcon, label: newLabel, leadingConstraint: trailing)
        self.selectedItem = newItem
        self.items.append(newItem)
        self.containerWidth.constant = CGFloat(self.items.count + 1) * (self.itemSpacing + plus.frame.width)
        
        self.slider.enabled = true
    }
    
    @objc private func removeItem(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began {
            return
        }
        guard let target = items.indexOf({$0.image == sender.view}) else {
            return
        }
        
        var right: Item?
        let this = items[target]
        var left: Item?
        if target > 0 {
            right = items[target - 1]
        }
        if target + 1 < items.count {
            left = items[target + 1]
        }
        
        this.leadingConstraint.active = false
        this.image.removeFromSuperview()
        this.label.removeFromSuperview()
        
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
        
        items.removeAtIndex(target)
        if items.count == 0 {
            self.slider.enabled = false
        }
        self.selectedItem = items.last
    }
    
    @objc private func selectItem(sender: UITapGestureRecognizer) {
        guard let target = items.indexOf({$0.image == sender.view}) else {
            return
        }
        self.selectedItem = items[target]
    }
    
    @IBAction func onSliderChange(sender: UISlider) {
        if items.count == 0 {
            sender.enabled = false
            sender.value = 0
        }
        var labelUnit = ""
        if let unit = self.unit {
            labelUnit = unit
        }
        if let item = self.selectedItem {
            item.value = sender.value
            var value = Int(sender.value * (self.max - self.min) + self.min)
            value = value - value%10
            item.label.text = "\(value)\n\(labelUnit)"
        }
    }
    

}
