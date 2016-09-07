//
//  LoginViewController.swift
//  Nino
//
//  Created by Danilo Becke on 2/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class GuardiansLoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Vars
    var textFields = [UITextField]()
    var buttons = [UIButton]()
    
    //MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.layer.cornerRadius = 5
        self.textFields.append(self.usernameTextField)
        self.textFields.append(self.passwordTextField)
        
        self.buttons.append(loginButton)
        
        for tf in self.textFields {
            tf.delegate = self
        }
        tryToAutoLogIn()
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
            self.userTriedToLogin()
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
     Handles the error and shows one alert
     
     - parameter error: Server Error throwed by login
     */
    private func errorAlert(error: ServerError) {
        let title = "Falha no login"
        let alert = DefaultAlerts.serverErrorAlert(error, title: title, customAction: nil)
        self.presentViewController(alert, animated: true, completion: nil)
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
        self.userTriedToLogin()
    }
    
    func userTriedToLogin(){
        if self.checkIfEmpty() {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
        } else{
            guard let username = usernameTextField.text else {
                return
            }
            guard let password = passwordTextField.text else {
                return
            }
            self.login(username, password: password)
            self.hideKeyboard()
        }
        
    }
    
    //MARK: Login method
    /**
     makes the login
     */
    private func login(username: String, password: String) {
        self.hideKeyboard()
        //all textFields are filled
        self.blockTextFields()
        self.blockButtons()
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        //creates a key and saves the login parameters at userDefaults and keychain
        let key = KeyBO.createKey(username, password: password)
        LoginBO.login(key, completionHandler: { (getCredential) in
            do {
                //tries to get the credential
                let credential = try getCredential()
                NinoSession.sharedInstance.setCredential(credential)
                //gets main queue to make UI changes
                GuardianBO.getStudents(credential.token, completionHandler: { (students) in
                    dispatch_async(dispatch_get_main_queue(), {
                        do {
                            let students = try students()
                            GuardiansSession.selectedStudent = students.first
                            GuardianBO.getGuardian({ (getProfile) in
                                do {
                                    let guardian = try getProfile()
                                    
                                    if guardian.name != nil && guardian.name!.isEmpty {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewControllerWithIdentifier("UpdateUserInfo")
                                        self.presentViewController(vc, animated: true, completion: nil)
                                    } else {
                                        self.activityIndicator.stopAnimating()
                                        //changes the view
                                        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                                            delegate.loggedIn = true
                                            delegate.setupRootViewController(true)
                                        }
                                    }
                                } catch {
                                    
                                }
                            })
                        } catch {
                            //TODO: Handle error
                        }
                    })
                })
            }
                //login error
            catch let error {
                //clean userDefaults and keychain
                KeyBO.removePasswordAndUsername()
                LoginDAO.logout({ (out) in
                    do {
                        try out();
                    } catch {
                        //TODO: Handle Error
                    }
                })
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.enableTextFields()
                    self.enableButtons()
                    if let serverError = error as? ServerError {
                        self.errorAlert(serverError)
                    }
                    self.passwordTextField.text = ""
                })
            }
        })
    }
    
    func tryToAutoLogIn(){
        guard let username = KeyBO.getUsername() else {
            return
        }
        guard let password = KeyBO.getPassword() else {
            return
        }
        self.passwordTextField.text = password
        self.usernameTextField.text = username
        login(username, password: password)
    }
    
    //MARK: Segue methods
    /**
     Unwind to login
     
     - parameter segue: unwind segue
     */
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }
    
}
