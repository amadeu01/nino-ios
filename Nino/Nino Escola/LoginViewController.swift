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
    
    
    /**
     Shows the page designed to creat new user without animations
     
     - parameter sender: UIButton
     */
    @IBAction func doNewUser(sender: UIButton) {
        //if you wanna present with animation, change the attribute at the storyboard
        self.hideKeyboard()
        performSegueWithIdentifier("createNewUser", sender: self)
    }
    
    
    
    //MARK: Login method
    /**
     makes the login
     */
    func login(username: String, password: String) {
        
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
                SchoolBO.getSchool(credential.token, completionHandler: { (school) in
                    do {
                        let school = try school()
                        NinoSession.sharedInstance.setSchool(school.id)
                        NinoNotificationManager.sharedInstance.addSchoolUpdatedNotification(self)
                        EducatorBO.getEducator(username, schoolID: school.schoolID!, token: credential.token, completionHandler: { (getProfile) in
                            do {
                                let educator = try getProfile()
                                NinoSession.sharedInstance.setEducator(educator.id)
                                self.activityIndicator.stopAnimating()
                                //changes the view
                                if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                                    delegate.loggedIn = true
                                    delegate.setupRootViewController(true)
                                }
                            } catch let error {
                                print("profileError")
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                //TODO: handle profile error
                            }
                        })
                        PhaseBO.getPhases(credential.token, schoolID: school.id, completionHandler: { (phases) in
                            do {
                                let phases = try phases()
                                if phases.count > 0 {
                                    let message = NotificationMessage()
                                    message.setDataToInsert(phases)
                                    NinoNotificationManager.sharedInstance.addPhasesWereUpdatedNotification(self, error: nil, info: message)
                                }
                            } catch let error {
                                print("getPhases error")
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                //TODO: handle getPhases and addPhases error
                            }
                        })
                        
                        DraftMechanism.getDrafts(credential.token, schoolID: 1, studentID: 2, completionHandler: { (info, error, data) in
                            
                        })
                        
                    } catch let error{
                        if let dataBaseError = error as? DatabaseError {
                            //There's no school. Let's create one
                            if dataBaseError == DatabaseError.NotFound {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewControllerWithIdentifier("CreateSchool")
                                self.presentViewController(vc, animated: true, completion: nil)
                            }
                        } else {
                            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                        }
                        print("getSchool error")
                        //TODO: handle getSchool error
                    }
                })
            }
                //login error
            catch let error {
                //clean userDefaults and keychain
                KeyBO.removePasswordAndUsername()
                LoginDAO.logout({ (out) in
                    do {
                        try out();
                    } catch let error {
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                        //TODO: Handle Error
                    }
                })
                self.activityIndicator.stopAnimating()
                self.enableTextFields()
                self.enableButtons()
                if let serverError = error as? ServerError {
                    self.errorAlert(serverError)
                }
                self.passwordTextField.text = ""
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
