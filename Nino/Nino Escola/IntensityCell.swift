//
//  IntensityCell.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/26/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class to represent a MyDay cell with different intensities, like little, medium and a lot, with just one possible selection
class IntensityCell: UITableViewCell {
    
    @IBOutlet weak var buttonsArea: UIView!
    @IBOutlet weak var title: UILabel!
    
        /// The current selection
    var selectedItem: UIButton? {
        willSet(newSelected) {
            //Sets the one selected before back to black
            selectedItem?.setTitleColor(UIColor.blackColor(), forState: .Normal)
            selectedItem?.subviews[1].backgroundColor = UIColor.blackColor()
            //Sets the new selected item to the nino color
            newSelected?.setTitleColor(UIColor(colorLiteralRed: 2/255, green: 119/255, blue: 155/255, alpha: 1), forState: .Normal)
            newSelected?.subviews[1].backgroundColor = UIColor(colorLiteralRed: 2/255, green: 119/255, blue: 155/255, alpha: 1)
        }
    }
        /// All Buttons
    var buttons: [UIButton] = []
    
        /// The diameter of the circle to the left of each option
    let circleDiameter: CGFloat = 7
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let view = UINib(nibName: "IntensityCell", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        if let cell = view {
            self.addSubview(cell)
            cell.frame = self.bounds
        }
    }
    
    /**
     Sets up the cell with all the options and the title
     
     - parameter label:   The title of this cell
     - parameter strings: An array containing all the options to this cell
     */
    func setup(label: String, strings: [String]) {
        //Sets title
        title.text = label
        
        //Clears the previous cell, as TableViewCells are reusable
        self.buttonsArea.subviews.forEach({$0.removeFromSuperview()})
        
        //Sets variables for buttons positioning
        let avaiableArea = self.frame.width //As the self is already with the final size, we use it
        var offset: CGFloat = 4
        let step = (avaiableArea-8)/CGFloat(strings.count) //The step is according to the number of options
        
        //Gets the margin of the cell
        let leftAnchor = self.buttonsArea.layoutMarginsGuide.leadingAnchor
        let centerAnchor = self.buttonsArea.layoutMarginsGuide.centerYAnchor
        
        //For each string we position a button it and add a circle to its left
        for string in strings {
            //Creates the button and adds the target function for clicks
            let button = UIButton()
            buttons.append(button)
            button.addTarget(self, action: #selector(self.tapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            //Sets the Visuals of the button
            button.setTitle(string, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
            
            self.buttonsArea.addSubview(button)

            //Positions it
            button.leadingAnchor.constraintEqualToAnchor(leftAnchor, constant: offset + 2 * circleDiameter).active = true
            button.centerYAnchor.constraintEqualToAnchor(centerAnchor).active = true
            
            //Creates and adds the circle
            let circle = UIView.init(frame: CGRectMake(0, 0, circleDiameter, circleDiameter))
            circle.layer.cornerRadius = circle.layer.frame.width/2
            circle.backgroundColor = UIColor.blackColor()
            circle.translatesAutoresizingMaskIntoConstraints = false
            
            button.addSubview(circle)
            
            //Positions the circle
            circle.centerYAnchor.constraintEqualToAnchor(button.centerYAnchor, constant: 0).active = true
            circle.trailingAnchor.constraintEqualToAnchor(button.leadingAnchor, constant: -circleDiameter).active = true
            circle.widthAnchor.constraintEqualToAnchor(nil, constant: circleDiameter-1).active = true
            circle.heightAnchor.constraintEqualToAnchor(nil, constant: circleDiameter-1).active = true
            
            offset += step
        }
    }
    
    /**
     On tap of a button the selected one will change to the recently tapped
     
     - parameter sender: the button clicked
     */
    @objc private func tapAction(sender: UIButton) {
        self.selectedItem = sender
    }

}
