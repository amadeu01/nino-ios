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
    
    static private func segueToLogin() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.loggedIn = false
            delegate.setupRootViewController(true)
        }
    }
    
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
    static func usedDidNotLoggedIn() -> UIAlertController {
        let alertView = UIAlertController(title: "Usuário não logado", message: "Você precisa estar logado no sistema para continuar", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Entendi", style: .Default) { (ok) in
            self.segueToLogin()
        }
        alertView.addAction(action)
        return alertView
    }
    
    /**
     Default alert to be used when one request returns an error
     
     - parameter error:        ServerError returned
     - parameter title:        Alert title
     - parameter customAction: Optional custom action
     
     - returns: UIAlertController ready to be presented
     */
    static func serverErrorAlert(error: ServerError, title: String, customAction: UIAlertAction?) -> UIAlertController {
        if error == ServerError.CouldNotConnectToTheServer {
            //TODO: send email notifying the server error
        }
        let alertView = UIAlertController(title: title, message: error.description(), preferredStyle: .Alert)
        if let action = customAction {
            alertView.addAction(action)
        } else {
            alertView.addAction(self.okAction)
        }
        return alertView
    }
    
    static func shouldDeleteAlert(confirmAction: UIAlertAction, customCancelAction: UIAlertAction?) -> UIAlertController {
        let alertView = UIAlertController(title: "Apagar Item", message: "Esse item será apagado permanentemente.", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Cancel, handler: nil))
        alertView.addAction(confirmAction)
        return alertView
    }
}
