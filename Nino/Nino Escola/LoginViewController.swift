//
//  LoginViewController.swift
//  Nino
//
//  Created by Danilo Becke on 13/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
//MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: Vars
    var textFields = [UITextField]()
    var buttons = [UIButton]()
    
//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.layer.cornerRadius = 5
        self.newUserButton.layer.cornerRadius = 5
        self.textFields.append(self.usernameTextField)
        self.textFields.append(self.passwordTextField)
        
        self.buttons.append(loginButton)
        self.buttons.append(newUserButton)
        
        for tf in self.textFields {
            tf.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil) && (nextResponder as? UITextField)?.text?.isEmpty == true {
            nextResponder?.becomeFirstResponder()
        } else {
            self.login()
        }
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
            if let txt = tf.text {
                if txt.isEmpty {
                    return true
                }
            } else {
                return true
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
    
//MARK: Alert methods
    /**
     Shows one alert telling the user that one or more fields are empty
     */
    private func emptyField() {
        let alertView = UIAlertController(title: "Campo vazio", message: "Nenhum campo pode estar vazio.", preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "Entendi", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
//MARK: Button methods
    /**
     The property enable of all text fields becomes false
     */
    private func blockButtons() {
        for btn in self.buttons {
            btn.alpha = 0.4
            btn.enabled = false
        }
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        for btn in self.buttons {
            btn.alpha = 1
            btn.enabled = true
        }
    }
    
    @IBAction func doLogin(sender: UIButton) {
        self.login()
    }
    
    @IBAction func doNewUser(sender: UIButton) {
        
    }
    
    
    
//MARK: Login method
    private func login() {
        self.hideKeyboard()
        if self.checkIfEmpty() {
            self.emptyField()
        } else {
            self.blockTextFields()
            self.blockButtons()
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            let key = KeyBO.createKey(self.usernameTextField.text!, password: self.passwordTextField.text!)
            LoginBO.login(key, completionHandler: { (getCredential) in
                do {
                    let credential = try getCredential()
                    NinoSession.sharedInstance.setCredential(credential)
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.activityIndicator.stopAnimating()
                        //TODO: Change page
                    })
                } catch let error {
                    KeyBO.removePasswordAndUsername()
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.activityIndicator.stopAnimating()
                        self.enableTextFields()
                        self.enableButtons()
                        //TODO: Handle error
                        print(error)
                    })
                }
            })
        }
    }

}
