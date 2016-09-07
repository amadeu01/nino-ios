//
//  StringsMechanisms.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Mechanism designed to handle string services
class StringsMechanisms: NSObject {

    private static let formatter = NSDateFormatter()
    
    /**
     Checks if an email is valid

     - parameter email: email to be checked

     - returns: a Bool type
     */
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailTest.evaluateWithObject(email)
    }
    
    /**
     Generates an unique identifier
     
     - returns: unique identifier
     */
    static func generateID() -> String {
        return NSUUID().UUIDString
    }
    
    static func convertDate(date: NSDate) -> String {
        self.formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        self.formatter.timeZone = NSTimeZone(name: "GMT")
        return self.formatter.stringFromDate(date)
    }
    
    static func dateFromString(date: String) -> NSDate {
        self.formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        self.formatter.timeZone = NSTimeZone(name: "GMT")
        guard let newDate = formatter.dateFromString(date) else {
            return NSDate()
        }
        return newDate
    }
    
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}
