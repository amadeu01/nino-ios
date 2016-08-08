//
//  RegisterPasswordViewController.swift
//  Nino
//
//  Created by Danilo Becke on 03/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

//FIXME: translate texts 
class RegisterPasswordViewController: UIViewController, UITextFieldDelegate {
    
//MARK: Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: Variables
    var userHash: String?

//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.delegate = self
        self.view.backgroundColor = CustomizeColor.defaultBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Button methods
    @IBAction func continueAction(sender: UIButton) {
        self.registerPassword()
    }
    
    /**
     The property enable of all text fields becomes false
     */
    private func blockButtons() {
        self.continueButton.alpha = 0.4
        self.continueButton.enabled = false
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        self.continueButton.alpha = 1
        self.continueButton.enabled = true
    }
    
//MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        //tests if next responder ir nil and is is empty
        guard let responder = nextResponder where (nextResponder as? UITextField)?.text?.isEmpty == true else {
            self.registerPassword()
            return false
        }
        
        responder.becomeFirstResponder()
        return false
    }
    
    /**
     The property enable of all text fields becomes false
     */
    private func blockTextFields() {
        for tf in self.textFields {
            tf.enabled = false
            tf.alpha = 0.4
        }
    }
    
    /**
     The property enable of all text fields becomes false
     */
    private func enableTextFields() {
        for tf in self.textFields {
            tf.enabled = true
            tf.alpha = 1
        }
    }
    
    /**
     Checks if there are text fields without text
     
     - returns: true if there are
     */
    private func checkIfEmpty() -> Bool {
        for tf in self.textFields {
            guard let txt = tf.text else {
                return true
            }
            if txt.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    /**
     Hides the keyboard
     */
    private func hideKeyboard() {
        for tf in self.textFields {
            tf.resignFirstResponder()
        }
    }
    
//MARK: Register password method
    private func registerPassword() {
        self.hideKeyboard()
        if self.checkIfEmpty() {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.blockTextFields()
        self.blockButtons()
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        //unexpected error
        guard let confirmHash = self.userHash else {
            let alertView = UIAlertController(title: "Falha no cadastro", message: "Ocorreu uma falha no cadastro da senha, tente novamente através do email recebido.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Entendi", style: .Default, handler: { (action) in
                self.segueToLogin()
            })
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        AccountBO.registerPassword(confirmHash, password: self.passwordTextField.text!) { (register) in
            do {
                let token = try register()
                let credential = CredentialBO.createCredential(token)
                NinoSession.sharedInstance.setCredential(credential)
                self.performSegueWithIdentifier("createSchool", sender: nil)
            } catch {
                //TODO:handle error and error data
            }
        }
    }
    
//MARK: Segue Methods
    private func segueToLogin() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.loggedIn = false
            delegate.setupRootViewController(true)
        }
    }

}
