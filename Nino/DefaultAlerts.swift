//
//  DefaultAlerts.swift
//  Nino
//
//  Created by Danilo Becke on 29/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class DefaultAlerts: NSObject {
    
    /**
     Default alert telling the user that one or more fields are empty
     
     - returns: UIAlertController ready to be presented
     */
    static func emptyField() -> UIAlertController {
        let alertView = UIAlertController(title: "Campo vazio", message: "Nenhum campo pode estar vazio.", preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Entendi", style: .Default, handler: nil)
        alertView.addAction(okAction)
        return alertView
    }
}
