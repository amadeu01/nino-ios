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
    
    /**
     Default alert to be used when the response from one request is ServerError.Timeout
     
     - parameter customAction: Custom action to be added to the AlertController
     
     - returns: UIAlertController ready to be presented
     */
    static func timeout(customAction: UIAlertAction?) -> UIAlertController {
        let alertView = UIAlertController(title: "Tempo excedido", message: "Cheque sua conexão com a internet e tente novamente. Se o problema persistir, entre em contato através de contato@ninoapp.com.br", preferredStyle: .Alert)
        if let action = customAction {
            alertView.addAction(action)
        } else {
            alertView.addAction(self.okAction)
        }
        return alertView
    }
    
    /**
     Default alert to be used when the response from one request is .InternetConnectionOffline or .CouldNotConnectToTheServer
     
     - parameter error:        ServerError response
     - parameter customAction: Custom action to be added to the AlertController
     
     - returns: UIAlertController ready to be presented
     */
    static func connectionError(error: ServerError, customAction: UIAlertAction?) -> UIAlertController {
        var title: String?
        var message: String?
        switch error {
        case .InternetConnectionOffline:
            title = "Sem internet"
            message = "Sua conexão com a internet parece estar offline. Cheque-a e tente novamente."
        case .CouldNotConnectToTheServer:
            title = "Problema interno"
            message = "Seu problema foi reportado, aguarde cerca de 5 minutos e tente novamente."
        //FIXME: send email notifying the server problem
        default:
            title = "Falha"
            message = "Tente novamente."
        }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        if let action = customAction {
            alertView.addAction(action)
        } else {
            alertView.addAction(self.okAction)
        }
        return alertView
    }
}
