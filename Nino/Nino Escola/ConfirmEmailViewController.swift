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
                    dispatch_async(dispatch_get_main_queue(), {
                        self.userHash = hash
                        self.performSegueWithIdentifier("registerPasssword", sender: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { 
                        let alertView = UIAlertController(title: "Falha de validação", message: "Já existe uma senha cadastrada para esse email.", preferredStyle: .Alert)
                        let action = UIAlertAction(title: "Entendi", style: .Default) { (ok) in
                            //FIXME: segue doesn't work
                            self.performSegueWithIdentifier("backToLoginSegue", sender: self)
                        }
                        alertView.addAction(action)
                        self.presentViewController(alertView, animated: true, completion: nil)
                    })
                }
            } catch let error {
                //TODO: handle error
                if error as? ServerError == ServerError.Timeout {
                    let action = UIAlertAction(title: "Entendi", style: .Default, handler: { (act) in
                        //FIXME: segue doesn't work
                        self.performSegueWithIdentifier("backToLoginSegue", sender: self)
                    })
                    let alertView = DefaultAlerts.timeout(action)
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.presentViewController(alertView, animated: true, completion: nil)
                    })
                }
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
    
}
