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
    var dataSource: GenderSelectorDataSource? {
        didSet {
            self.changeLabels()
        }
    }
    var delegate: GenderSelectorDelegate?
    
//MARK: Outlets
    @IBOutlet weak var male: UIView!
    @IBOutlet weak var maleIcon: UIImageView!
    @IBOutlet weak var maleLabel: UILabel! {
        didSet {
            maleLabel.text = NSLocalizedString("PROF_GEN_BOY", comment: "Boy")
        }
    }
    @IBOutlet weak var female: UIView!
    @IBOutlet weak var femaleIcon: UIImageView!
    @IBOutlet weak var femaleLabel: UILabel! {
        didSet {
            femaleLabel.text = NSLocalizedString("PROF_GEN_GIRL", comment: "Girl")
        }
    }
    
//MARK: View initialization methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed("GenderSelector", owner: self, options: nil)![0] as? UIView
        if let selectGender = view {
            self.addSubview(selectGender)
            selectGender.frame = self.bounds
        }
    }
    
    
//MARK: DataSource updates
    private func changeLabels() {
        if let maleLabel = dataSource?.changeMaleLabel() {
            self.maleLabel.text = maleLabel
        }
        if let femaleLabel = dataSource?.changeFemaleLabel() {
            self.femaleLabel.text = femaleLabel
        }
    }
    
//MARK: Button methods
    /**
     Handles when the user taps male
     
     - parameter sender: TapGesture
     */
    @IBAction func maleWasTouched(sender: UITapGestureRecognizer) {
        self.maleIcon.image = UIImage(named: "icone-masculino-azul")
        self.maleLabel.font = UIFont.init(name: "HelveticaNeue-Bold", size: 15.0)
        self.maleLabel.textColor = UIColor(red: 0, green: 162/255, blue: 173/255, alpha: 1)
        self.femaleIcon.image = UIImage(named: "icone-feminino-cinza")
        self.femaleLabel.font = UIFont.init(name: "HelveticaNeue-Light", size: 15.0)
        self.femaleLabel.textColor = UIColor.blackColor()
        self.delegate?.genderWasSelected(Gender.Male)
    }
    
    /**
     Handles when the user taps female
     
     - parameter sender: TapGesture
     */
    @IBAction func femaleWasTouched(sender: UITapGestureRecognizer) {
        self.femaleIcon.image = UIImage(named: "icone-feminino-azul")
        self.femaleLabel.font = UIFont.init(name: "HelveticaNeue-Bold", size: 15.0)
        self.femaleLabel.textColor = UIColor(red: 0, green: 162/255, blue: 173/255, alpha: 1)
        self.maleIcon.image = UIImage(named: "icone-masculino-cinza")
        self.maleLabel.font = UIFont.init(name: "HelveticaNeue-Light", size: 15.0)
        self.maleLabel.textColor = UIColor.blackColor()
        self.delegate?.genderWasSelected(Gender.Female)
    }
    
    
}
//MARK: Delegate and DataSource
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
