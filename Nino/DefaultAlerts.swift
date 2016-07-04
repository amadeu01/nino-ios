//
//  DefaultAlerts.swift
//  Nino
//
//  Created by Danilo Becke on 29/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

//FIXME: translate texts
class DefaultAlerts: NSObject {
    
    static private let okAction = UIAlertAction(title: "Entendi", style: .Default, handler: nil)
    
    /**
     Default alert to be used when one or more fields are empty
     
     - returns: UIAlertController ready to be presented
     */
    
    static func emptyField() -> UIAlertController {
        let alertView = UIAlertController(title: "Campo vazio", message: "Nenhum campo pode estar vazio.", preferredStyle:.Alert)
        alertView.addAction(self.okAction)
        return alertView
    }
    
    /**
     Default alert to be used when the email is invalid
     
     - returns: UIAlertController ready to be presented
     */
    static func invalidEmail() -> UIAlertController {
        let alertView = UIAlertController(title: "Email inválido", message: "Digite um email válido", preferredStyle: .Alert)
        alertView.addAction(self.okAction)
        return alertView
    }
    
    /**
     Default alert to be used when the user needs to be logged in
     
     - returns: UIAlertController ready to be presented
     */
    static func usedDidNotLoggedIn(from: UIViewController) -> UIAlertController {
        let alertView = UIAlertController(title: "Usuário não logado", message: "Você precisa estar logado no sistema para continuar", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Entendi", style: .Default) { (ok) in
            from.performSegueWithIdentifier("backToLoginSegue", sender: self)
        }
        alertView.addAction(action)
        return alertView
    }
}
