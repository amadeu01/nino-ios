//
//  ConfirmEmailViewController.swift
//  Nino
//
//  Created by Danilo Becke on 04/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

//FIXME: translate texts
class GuardiansConfirmEmailViewController: UIViewController {
    
    //MARK: Variables
    private var userHash: String?
    
    //MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomizeColor.defaultBackgroundColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARKL Check hash
    /**
     Checks if the confirmation hash is valid
     
     - parameter hash: confirmation hash received by email
     
     */
    func isValidHash(hash: String) {
        AccountBO.checkIfValidated(hash) { (checkHash) in
            do {
                let isValid = try checkHash()
                if isValid {
                    self.userHash = hash
                    self.performSegueWithIdentifier("registerPasssword", sender: nil)
                } else {
                    let alertView = UIAlertController(title: "Falha de validação", message: "Já existe uma senha cadastrada para esse email.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Entendi", style: .Default) { (ok) in
                        self.segueToLogin()
                    }
                    alertView.addAction(action)
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            } catch let error {
                //TODO: handle error
                guard let serverError = error as? ServerError else {
                    NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    return
                }
                let action = UIAlertAction(title: "Entendi", style: .Default, handler: { (act) in
                    self.segueToLogin()
                    let alertView = DefaultAlerts.serverErrorAlert(serverError, title: "Falha na confirmação", customAction: act)
                    self.presentViewController(alertView, animated: true, completion: nil)
                })
                let alertView = DefaultAlerts.serverErrorAlert(serverError, title: "Falha na confirmação", customAction: action)
                self.presentViewController(alertView, animated: true, completion: nil)
                
            }
        }
    }
    
    //MARK: Segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "registerPasssword" {
            let destVC = segue.destinationViewController as? GuardiansRegisterPasswordViewController
            destVC?.userHash = self.userHash
        }
    }
    
    private func segueToLogin() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.loggedIn = false
            delegate.setupRootViewController(true)
        }
    }
    
}
