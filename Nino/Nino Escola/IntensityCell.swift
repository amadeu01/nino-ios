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
    var delegate: MyDayCellDelegate?
    var indexPath: NSIndexPath?
    private var cellValues: [[String: String]]?
    private var isLeftCell: Bool?
    private var values = [-1]
    private var current = 0
    
    /// The current selection
    var selectedItem: UIButton? {
        willSet(newSelected) {
            //Sets the one selected before back to black
            selectedItem?.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
            selectedItem?.setTitleColor(UIColor.blackColor(), forState: .Normal)
            selectedItem?.subviews[1].backgroundColor = UIColor.blackColor()
            //Sets the new selected item to the nino color
            newSelected?.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
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
    func setup(label: String, buttonsStrings: [[String: String]], delegate: MyDayCellDelegate, indexPath: NSIndexPath, isLeftCell: Bool, values: [Int]?, current: Int?) {
        //Sets title
        self.title.text = label
        self.delegate = delegate
        self.indexPath = indexPath
        self.cellValues = buttonsStrings
        self.isLeftCell = isLeftCell
        if let array = values {
            self.values = array
        }
        if let value = current {
            self.current = value
        }
        
        //Clears the previous cell, as TableViewCells are reusable
        self.buttonsArea.subviews.forEach({$0.removeFromSuperview()})
        
        //Sets variables for buttons positioning
        let avaiableArea = self.frame.width //As the self is already with the final size, we use it
        var offset: CGFloat = 4
        let step = (avaiableArea-8)/CGFloat(buttonsStrings.count) //The step is according to the number of options
        
        //Gets the margin of the cell
        let leftAnchor = self.buttonsArea.layoutMarginsGuide.leadingAnchor
        let centerAnchor = self.buttonsArea.layoutMarginsGuide.centerYAnchor
        
        //For each string we position a button it and add a circle to its left
        var position = 0
        for buttonDict in buttonsStrings {
            //Creates the button and adds the target function for clicks
            let button = UIButton()
            button.tag = position
            buttons.append(button)
            button.addTarget(self, action: #selector(self.tapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            //Sets the Visuals of the button
            guard let title = buttonDict["title"] else {
                //never will be reached, I hope
                //TODO: handle missing button title
                return
            }
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
            button.titleLabel?.minimumScaleFactor = 0.2
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.contentHorizontalAlignment = .Left
            self.buttonsArea.addSubview(button)

            //Positions it
            button.leadingAnchor.constraintEqualToAnchor(leftAnchor, constant: offset + 2 * circleDiameter).active = true
            button.centerYAnchor.constraintEqualToAnchor(centerAnchor).active = true
            button.widthAnchor.constraintEqualToConstant(step - 2 * circleDiameter).active = true
            


            
            //Creates and adds the circle
            let circle = UIView()
            circle.layer.cornerRadius = circleDiameter/2
            circle.backgroundColor = UIColor.blackColor()
            circle.translatesAutoresizingMaskIntoConstraints = false
            
            button.addSubview(circle)
            
            //Positions the circle
            circle.centerYAnchor.constraintEqualToAnchor(button.centerYAnchor, constant: 0).active = true
            circle.trailingAnchor.constraintEqualToAnchor(button.leadingAnchor, constant: -circleDiameter).active = true
            circle.widthAnchor.constraintEqualToAnchor(nil, constant: circleDiameter-1).active = true
            circle.heightAnchor.constraintEqualToAnchor(nil, constant: circleDiameter-1).active = true
            
            offset += step
            position += 1
        }
        self.initializeValues()
    }
    
    func getStatus() -> String? {
        return selectedItem?.titleLabel?.text
    }
    
    /**
     On tap of a button the selected one will change to the recently tapped
     
     - parameter sender: the button clicked
     */
    @objc private func tapAction(sender: UIButton) {
        if self.selectedItem == sender {
            self.selectedItem = nil
            if let index = self.indexPath {
                if let isLeft = self.isLeftCell {
                    self.values[self.current] = -1
                    delegate?.didChangeStatus(-1, indexPath: index, isLeftCell: isLeft)
                }
            }
        } else {
            self.selectedItem = sender
            if let index = self.indexPath {
                if let isLeft = self.isLeftCell {
                    self.values[self.current] = sender.tag
                    delegate?.didChangeStatus(sender.tag, indexPath: index, isLeftCell: isLeft)
                }
            }
        }
    }
    
    private func initializeValues() {
        let tag = self.values[current]
        if tag != -1 {
            for button in self.buttons {
                if button.tag == tag {
                    self.selectedItem = button
                }
            }
        } else {
            selectedItem = nil
        }
    }
    
    func addItem() {
        self.current = self.values.count
        self.values.append(-1)
        self.initializeValues()
    }
    
    func changeSelected(current: Int) {
        self.current = current
        self.initializeValues()
    }
    
    func deleteItem(position: Int) {
        self.values.removeAtIndex(position)
        self.current = self.values.count - 1
        self.initializeValues()
    }
    
    func disableInteraction() {
        for button in self.buttons {
            button.userInteractionEnabled = false
        }
    }
    
    func enableInteraction() {
        for button in self.buttons {
            button.userInteractionEnabled = true
        }
    }

}
