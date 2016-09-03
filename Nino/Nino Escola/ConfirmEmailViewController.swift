//
//  ConfirmEmailViewController.swift
//  Nino
//
//  Created by Danilo Becke on 04/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

//FIXME: translate texts
class ConfirmEmailViewController: UIViewController {

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
                    let alertView = UIAlertController(title: NSLocalizedString("VALIDATION_FAILED", comment: ""), message: NSLocalizedString("ALREADY_HAS_PSSWD", comment: ""), preferredStyle: .Alert)
                    let action = UIAlertAction(title: NSLocalizedString("GENERAL_GOTIT", comment: ""), style: .Default) { (ok) in
                        self.segueToLogin()
                    }
                    alertView.addAction(action)
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            } catch let error {
                //TODO: handle error
                guard let serverError = error as? ServerError else {
                    return
                }
                let action = UIAlertAction(title: NSLocalizedString("GENERAL_GOTIT", comment: ""), style: .Default, handler: { (act) in
                    self.segueToLogin()
                })
                let alertView = DefaultAlerts.serverErrorAlert(serverError, title: NSLocalizedString("CONFIRMATION_FAILED", comment: ""), customAction: action)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
    
//MARK: Segue methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "registerPasssword" {
            let destVC = segue.destinationViewController as? RegisterPasswordViewController
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
