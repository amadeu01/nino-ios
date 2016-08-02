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
        self.login()
    }
    
    //MARK: Login method
    /**
     makes the login
     */
    private func login() {
        self.hideKeyboard()
        if self.checkIfEmpty() {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
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
//                    //tries to get the credential
//                    let credential = try getCredential()
//                    NinoSession.sharedInstance.setCredential(credential)
//                    //get educator info and school ID
//                    EducatorBO.getEducator(self.usernameTextField.text!, token: credential.token, completionHandler: { (getProfileAndSchoolID) in
//                        do {
//                            //tries to get the current educator
//                            let (educator, schoolID) = try getProfileAndSchoolID()
//                            NinoSession.sharedInstance.setEducator(educator.id)
//                            //get school info
//                            SchoolBO.getSchool(credential.token, schoolServerID: schoolID, completionHandler: { (school) in
//                                do {
//                                    let school = try school()
//                                    NinoSession.sharedInstance.setSchool(school.id)
//                                    //posting notification
//                                    NinoSessionNotificationManager.sharedInstance.addSchoolUpdatedNotification(self)
//                                    //get phases
//                                    PhaseBO.getPhases(credential.token, schoolID: school.id, completionHandler: { (phases) in
//                                        do {
//                                            let phases = try phases()
//                                            try PhaseBO.addPhasesInSchool(phases)
//                                            NinoSessionNotificationManager.sharedInstance.addPhasesUpdatedNotification(self)
//                                            for phase in phases {
//                                                //get rooms for each phase
//                                                RoomBO.getRooms(credential.token, phaseID: phase.id, completionHandler: { (rooms) in
//                                                    do {
//                                                        let allRooms = try rooms()
//                                                        try RoomBO.addRoomsInPhase(allRooms, phase: phase.id)
//                                                    } catch let error {
//                                                        //TODO: handle getRoom and addRooms errors
//                                                        print("getRoom error: " + ((error as? ServerError)?.description())!)
//                                                    }
//                                                })
//                                            }
//                                        } catch {
//                                            //TODO: handle getPhases and addPhases error
//                                        }
//                                    })
//                                } catch {
//                                    //TODO: handle getSchool error
//                                }
//                            })
//                            //gets main queue to make UI changes
//                            dispatch_async(dispatch_get_main_queue(), {
//                                self.activityIndicator.stopAnimating()
//                                //changes the view
//                                if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
//                                    delegate.loggedIn = true
//                                    delegate.setupRootViewController(true)
//                                }
//                            })
//                        }
//                            //getEducator error
//                        catch let profileError {
//                            //TODO: handle profile error
//                        }
//                    })
                }
                    //login error
                catch let error {
//                    //clean userDefaults and keychain
//                    KeyBO.removePasswordAndUsername()
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.activityIndicator.stopAnimating()
//                        self.enableTextFields()
//                        self.enableButtons()
//                        if let serverError = error as? ServerError {
//                            self.errorAlert(serverError)
//                        }
//                        self.passwordTextField.text = ""
//                    })
                }
            })
        }
    }
    
    //MARK: Segue methods
    /**
     Unwind to login
     
     - parameter segue: unwind segue
     */
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }
    
}
