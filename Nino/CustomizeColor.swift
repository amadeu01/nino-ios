//
//  CustomizeColor.swift
//  Nino
//
//  Created by Danilo Becke on 14/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class CustomizeColor: UIColor {
    
    static func navColour() -> UIColor {
        return UIColor(red: 196/255, green: 224/255, blue: 249/255, alpha: 1)
    }
    
    static func navColourWithAlpha(alpha: CGFloat) -> UIColor {
        return UIColor(red: 196/255, green: 224/255, blue: 249/255, alpha: alpha)
    }
    
    static func strongBackgroundNino() -> UIColor {
        return UIColor(red: 2/255, green: 119/255, blue: 155/255, alpha: 1)
    }
    
    static func lessStrongBackgroundNino() -> UIColor {
        return UIColor(red: 0, green: 162/255, blue: 173/255, alpha: 1)
    }
    
    static func borderColourNino() -> UIColor {
        return UIColor(red: 111/255, green: 230/255, blue: 238/255, alpha: 1)
    }
    
    
    static func fontColourNino() -> UIColor {
        return UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1)
    }
    
    static func clearBackgroundNino() -> UIColor {
        return UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    static func whiteFontColourNino() -> UIColor {
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    }
    
    static func defaultBackgroundColor() -> UIColor {
        return UIColor(patternImage: UIImage(named: "backgroundBolas")!)
    }
    

}

extension UIViewController {
    
    /**
     Adds an image to the View Controller Background
     
     - parameter image: image that should fill the background
     */
    func addBackgroundWithImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        let backGround = UIImageView(image: image)
        backGround.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backGround)
        self.view.sendSubviewToBack(backGround)
    }
    
    func addNinoDefaultBackGround() {
        addBackgroundWithImage(UIImage(named: "backgroundBolas"))
    }
}
