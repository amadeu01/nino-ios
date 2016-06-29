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
    
    /**
     Handles the error and shows one alert
     
     - parameter error: Server Error throwed by login
     */
    private func errorAlert(error: ServerError) {
        var title: String?
        var message: String?
        switch error {
        case ServerError.BadRequest:
            self.emptyField()
        case ServerError.NotFound:
            title = "Dados inválidos"
            message = "Usuário ou senha inválidos."
        default:
            title = "Falha no login"
            message = "Tente novamente."
        }
        if let tt = title {
            if let txt = message {
                let alertView = UIAlertController(title: tt, message: txt, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Entendi", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
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
    
    /**
     Shows the page designed to creat new user without animations
     
     - parameter sender: UIButton
     */
    @IBAction func doNewUser(sender: UIButton) {
        //if you wanna present with animation, change the attribute at the storyboard
        performSegueWithIdentifier("createNewUser", sender: self)
    }
    
    
    
//MARK: Login method
    /**
     makes the login
     */
    private func login() {
        self.hideKeyboard()
        if self.checkIfEmpty() {
            self.emptyField()
        }
        //all textFields are filled
        else {
            self.blockTextFields()
            self.blockButtons()
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            //creates a key and saves the login parameters at userDefaults and keychain
            let key = KeyBO.createKey(self.usernameTextField.text!, password: self.passwordTextField.text!)
            LoginBO.login(key, completionHandler: { (getCredential) in
                do {
                    //tries to get the credential
                    let credential = try getCredential()
                    //TODO: save active educator on NinoSession
                    NinoSession.sharedInstance.setCredential(credential)
                    //gets main queue to make UI changes
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.activityIndicator.stopAnimating()
                        //changes the view
                        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                            delegate.loggedIn = true
                            delegate.setupRootViewController(true)
                        }
                    })
                } catch let error {
                    //clean userDefaults and keychain
                    KeyBO.removePasswordAndUsername()
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.activityIndicator.stopAnimating()
                        self.enableTextFields()
                        self.enableButtons()
                        if let serverError = error as? ServerError {
                            self.errorAlert(serverError)
                        }
                    })
                }
            })
        }
    }
    
//MARK: Segue methods
    /**
     Unwind from create school view
     
     - parameter segue: unwind segue
     */
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }

}
