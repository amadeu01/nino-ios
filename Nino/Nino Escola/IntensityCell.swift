//
//  IntensityCell.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/26/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class IntensityCell: UITableViewCell {
    
    @IBOutlet weak var buttonsArea: UIView!
    @IBOutlet weak var title: UILabel!
    let circleDiameter: CGFloat = 7
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let view = UINib(nibName: "IntensityCell", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        if let cell = view {
            self.addSubview(cell)
            cell.frame = self.bounds
        }
    }
    
    func setup(label: String, strings: [String]) {
        //Sets title
        title.text = label
        
        //Clears the previous cell, as TableViewCells are reusable
        self.buttonsArea.subviews.forEach({$0.removeFromSuperview()})
        
        //Sets variables for buttons positioning
        let avaiableArea = self.frame.width
        var offset: CGFloat = 4
        let step = (avaiableArea-8)/CGFloat(strings.count)
        
        let leftAnchor = self.buttonsArea.layoutMarginsGuide.leadingAnchor
        let centerAnchor = self.buttonsArea.layoutMarginsGuide.centerYAnchor
        
        for string in strings {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.setTitle(string, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.titleLabel!.font = UIFont(name: "Helvetica Neue Thin", size: 12)
            
            self.buttonsArea.addSubview(button)

            button.leadingAnchor.constraintEqualToAnchor(leftAnchor, constant: offset + 2 * circleDiameter).active = true
            button.centerYAnchor.constraintEqualToAnchor(centerAnchor).active = true
            
            let circle = UIView.init(frame: CGRectMake(0, 0, circleDiameter, circleDiameter))
            circle.layer.cornerRadius = circle.layer.frame.width/2
            circle.backgroundColor = UIColor.blackColor()
            circle.translatesAutoresizingMaskIntoConstraints = false
            
            button.addSubview(circle)
            
            circle.centerYAnchor.constraintEqualToAnchor(button.centerYAnchor, constant: 0).active = true
            circle.trailingAnchor.constraintEqualToAnchor(button.leadingAnchor, constant: -circleDiameter).active = true
            circle.widthAnchor.constraintEqualToAnchor(nil, constant: circleDiameter-1).active = true
            circle.heightAnchor.constraintEqualToAnchor(nil, constant: circleDiameter-1).active = true
            
            offset += step
        }
    }

}
