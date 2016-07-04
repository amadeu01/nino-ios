//
//  NinoFont.swift
//  ninoEscola
//
//  Created by Amadeu Cavalcante on 25/11/2015.
//  Copyright © 2015 Alfredo Cavalcante Neto. All rights reserved.
//

import UIKit

class NinoFont: UIFont {

    //MARK: - Master Header
    
    static func fontForMasterHeader() -> UIFont {
        
        return UIFont(name: "HelveticaNeue-Bold", size: 20)!
        
    }
    
    static func fontForMasterHeaderSecondText() -> UIFont {
        
        return UIFont(name: "HelveticaNeue", size: 16)!
        
    }
    
    static func fontForBabyNameMasterHeader() -> UIFont {
        return UIFont(name: "HelveticaRoundedLT-BoldCond", size: 20)!
    }
    
     //MARK: - ProfileCell
    
    static func fontForCellMainText() -> UIFont {
        return UIFont(name: "HelveticaRoundedLT-Bold", size: 18)!
    }
    
    static func fontForCellSecondText() -> UIFont {
        
        return UIFont(name: "HelveticaNeue", size: 13)!
    }
    
    static func fontForCellThirdText() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 16)!
    }
    
     //MARK: - Detail Header
    
    static func fontForDetailHeader() -> UIFont {
        
        return UIFont(name: "HelveticaNeue-Bold", size: 17)!
    }
    
    static func fontForDetailHeaderSecondText() -> UIFont {
        
        return UIFont(name: "HelveticaNeue-Thin", size: 16)!
    }
    
    //MARK: - Buttons Fonts
    
    static func fontForButtons() -> UIFont {
        
        return UIFont(name: "HelveticaRoundedLT-Bold", size: 12)!
    }
    
    static func findOutFonts() {
        for family: String in UIFont.familyNames() {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family) {
                print("== \(names)")
            }
        }
        
    }
    
}
