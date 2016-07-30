//
//  ExpandableSelectableTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/29/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ExpandableSelectableTableViewCell: UITableViewCell {

    @IBOutlet weak var arrow: UIView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //print("1 - It was \(arrow.frame)")
        //arrow.layoutIfNeeded()
        //print ("2 - Became \(arrow.frame)")
        //arrow.layer.addSublayer(trianglePathFromView(arrow))
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("It was \(arrow.frame)")
        arrow.layoutIfNeeded()
        print ("Became \(arrow.frame)")
        arrow.layer.addSublayer(trianglePathFromView(arrow))
    }
    
    

    func trianglePathFromView (view: UIView) -> CAShapeLayer  {
        let drawPath = UIBezierPath()
        drawPath.moveToPoint(CGPoint(x: 0, y: 0))
        drawPath.addLineToPoint(CGPoint(x: view.bounds.size.width, y: view.bounds.size.height/2))
        drawPath.addLineToPoint(CGPoint(x: 0, y: view.bounds.size.height))
        drawPath.closePath()
        let thisLayer = CAShapeLayer()
        thisLayer.path = drawPath.CGPath
        thisLayer.fillColor = UIColor.blueColor().CGColor
        thisLayer.fillRule = kCAFillRuleNonZero
        thisLayer.lineCap = kCALineCapButt
        thisLayer.lineDashPattern = nil
        thisLayer.lineDashPhase = 0
        thisLayer.lineJoin = kCALineJoinMiter
        thisLayer.lineWidth = 1.0
        thisLayer.miterLimit = 10.0
        thisLayer.strokeColor = UIColor.blueColor().CGColor
        return thisLayer
        
    }
}
