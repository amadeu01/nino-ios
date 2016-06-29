//
//  GenderSelector.swift
//  Nino
//
//  Created by Danilo Becke on 28/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Custom component designed to manage gender selection
class GenderSelector: UIView, UIGestureRecognizerDelegate {

//MARK: DataSource and Delegate
    var dataSource: GenderSelectorDataSource?
    var delegate: GenderSelectorDelegate?
    
//MARK: Outlets
    @IBOutlet weak var male: UIView!
    @IBOutlet weak var maleIcon: UIImageView!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var female: UIView!
    @IBOutlet weak var femaleIcon: UIImageView!
    @IBOutlet weak var femaleLabel: UILabel!
    
//MARK: View initialization methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed("GenderSelector", owner: self, options: nil)[0] as? UIView
        if let selectGender = view {
            self.addSubview(selectGender)
            selectGender.frame = self.bounds
        }
    }
    
    /**
     Should be called when you want to reload the view. To do this, use view.setNeedsLayout()
     */
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let maleLabel = dataSource?.changeMaleLabel() {
            self.maleLabel.text = maleLabel
        }
        if let femaleLabel = dataSource?.changeFemaleLabel() {
            self.femaleLabel.text = femaleLabel
        }
    }
    
    /**
     Handles when the user taps male
     
     - parameter sender: TapGesture
     */
    @IBAction func maleWasTouched(sender: UITapGestureRecognizer) {
        self.maleIcon.image = UIImage(named: "icone-masculino-azul")
        self.maleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        self.maleLabel.textColor = UIColor(red: 0, green: 162/255, blue: 173/255, alpha: 1)
        self.femaleIcon.image = UIImage(named: "icone-feminino-cinza")
        self.femaleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        self.femaleLabel.textColor = UIColor.blackColor()
        self.delegate?.genderWasSelected(Gender.Male)
    }
    
    /**
     Handles when the user taps female
     
     - parameter sender: TapGesture
     */
    @IBAction func femaleWasTouched(sender: UITapGestureRecognizer) {
        self.femaleIcon.image = UIImage(named: "icone-feminino-azul")
        self.femaleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        self.femaleLabel.textColor = UIColor(red: 0, green: 162/255, blue: 173/255, alpha: 1)
        self.maleIcon.image = UIImage(named: "icone-masculino-cinza")
        self.maleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        self.maleLabel.textColor = UIColor.blackColor()
        self.delegate?.genderWasSelected(Gender.Female)
    }
    
    
}

/**
 *  Delegate to notify when the user selects one gender
 */
protocol GenderSelectorDelegate {
    /**
     Delegate function called when the user selects one gender
     
     - parameter gender: selected gender
     */
    func genderWasSelected(gender: Gender)
}

/**
 *  DataSource to change the labels
 */
protocol GenderSelectorDataSource {
    /**
     DataSource function to change the male label
     
     - returns: new label
     */
    func changeMaleLabel() -> String
    /**
     DataSource function to change the female label
     
     - returns: new label
     */
    func changeFemaleLabel() -> String
}
