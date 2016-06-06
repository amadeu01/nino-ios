//
//  StringsValidation.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Mechanism designed to check if a string is valid
class StringsValidation: NSObject {

    /**
     Check if an email is valid

     - parameter email: email to be checked

     - returns: a Bool type
     */
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailTest.evaluateWithObject(email)
    }
}
