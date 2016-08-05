//
//  ExpandableSelectableTableViewCell.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/29/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import BEMCheckBox

class ExpandableSelectableTableViewCell: UITableViewCell {
    @IBOutlet weak var identationDistance: NSLayoutConstraint!
    
    //@IBOutlet weak var arrow: UIView! {
    @IBOutlet weak var arrowButton: UIButton! {
        didSet {
            arrowButton.imageView?.contentMode = UIViewContentMode.Center
        }
    }
//    @IBOutlet weak var checkBox: UIView! {
//        didSet {
//            let blu = (checkBox as? BEMCheckBox)
//            blu?.onFillColor = CustomizeColor.lessStrongBackgroundNino()
//            blu?.onCheckColor = UIColor.whiteColor()
//            blu?.onTintColor = CustomizeColor.lessStrongBackgroundNino()
//            blu?.animationDuration = 0.3
//            blu?.onAnimationType = .Fill
//            blu?.offAnimationType = .Fill
//            blu?.delegate = self
//        }
//    }
    
    @IBOutlet weak var thisSwitch: UISwitch! {
        didSet {
            thisSwitch.addTarget(self, action: #selector(didChangeSwitch), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
        @IBOutlet weak var title: UILabel!
    weak var delegate: ExpandableSelectableTableViewCellDelegate?
    var value: String? {
        didSet {
        title.text = value
        }
    }
    /// An integer that describes the hierarchical order. Changing this variable automatically changes the indentation level of the cell
    var infoHier: Int {
        didSet {
            self.indentationLevel = infoHier
            self.identationDistance.constant = 16 + (CGFloat)(infoHier) * 20
        }
    }
    var hasSons: Bool {
        didSet {
            self.arrowButton.hidden = !(hasSons)
        }
    }//Indicates whether the cell has sons
    var isExpanded: Bool
    var checkBoxSelected = false {
        didSet {
//            guard let blu = (checkBox as? BEMCheckBox) else {
//                return
//            }
//            if oldValue != checkBoxSelected {
//               blu.setOn(checkBoxSelected, animated: true)
//            }
            //checkBox.layoutSubviews()
            //checkBox.layoutIfNeeded()
            thisSwitch.setOn(checkBoxSelected, animated: true)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        self.infoHier = 0
        self.value = nil
        self.hasSons = false
        self.isExpanded = false
        self.checkBoxSelected = false
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indentationWidth = 30
        self.indentationLevel = 4
        //let clickInArrow = UITapGestureRecognizer(target: arrow, action: #selector(self.didClickInArrow))
        //clickInArrow.numberOfTapsRequired = 1
        //arrow.addGestureRecognizer(clickInArrow)
    }
    func didClickInArrow() {
        if self.isExpanded {
            shouldCollapse()
        } else {
            shouldExpand()
        }
        
    }
//    func configureCell(value: String, profileImage: UIImage?, infoHier: Int, hasSons: Bool) {
//        self.value = value
//        self.infoHier = infoHier
//        self.hasSons = hasSons
//    }
    func shouldExpand() {
        if hasSons == false {
            print("Trying to expand a cell which does not has sons")
            return
        }
        if isExpanded == true {
            print("Trying to expand a cell which is already expanded")
            return
        }
        self.isExpanded = true
        rotate(90)
        self.delegate?.didExpand(self)
    }
    func shouldCollapse() {
        if hasSons == false {
            print("Trying to collapse a cell which does not has sons")
            return
        }
        if isExpanded == false {
            print("Trying to collapse a cell which is already expanded")
            return
        }
        self.isExpanded = false
        rotate(0)
        self.delegate?.didCollapse(self)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
 //     arrow.layoutIfNeeded()
 //     arrow.layer.addSublayer(trianglePathFromView(arrow))//create the triangle
    }
    
    func rotate(degrees: CGFloat) {
        arrowButton.imageView!.animate(0.3, animations: {
            let rads:CGFloat = degrees * CGFloat(M_PI)/180
            self.arrowButton.imageView?.transform = CGAffineTransformMakeRotation(rads)
        }) { (finished) in
            print("Did rotate")
        }
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
    @IBAction func thisButtonWorked(sender: AnyObject) {
        print("The button worked")
        if self.isExpanded {
            shouldCollapse()
        }else {
            shouldExpand()
        }
        
    }
    
    //MARK: BEMCheckBox Delegate
    
    func didTapCheckBox(checkBox: BEMCheckBox) {
        if checkBox.on {
            self.delegate?.didSelect(self)
        }else{
            self.delegate?.didUnselect(self)
        }
    }
    func didChangeSwitch(sender: UISwitch) {
        if thisSwitch.on {
            self.delegate?.didSelect(self)
        } else {
            self.delegate?.didUnselect(self)        }
    }
}
protocol ExpandableSelectableTableViewCellDelegate: class {
    func didExpand(cell: ExpandableSelectableTableViewCell)
    func didCollapse(cell: ExpandableSelectableTableViewCell)
    func didSelect(cell: ExpandableSelectableTableViewCell)
    func didUnselect(cell: ExpandableSelectableTableViewCell)
}
