//
//  Gender.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 Class designed to manage genders
 
 - Male:   Male type
 - Female: Female type
 */
enum Gender: Int {
    case Male
    case Female
    
    func description() -> String {
        switch self {
        case .Male:
            return NSLocalizedString("PROF_GEN_MALE", comment: "Male")
        case .Female:
            return NSLocalizedString("PROF_GEN_FEMALE", comment: "Femail")
        }
    }
}
