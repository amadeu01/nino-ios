//
//  CreateUserViewController.swift
//  Nino
//
//  Created by Danilo Becke on 29/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController, UITextFieldDelegate, GenderSelectorDelegate, GenderSelectorDataSource {
    
//MARK: Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var genderSelector: GenderSelector!
    
//MARK: Variables
    private var gender: Gender?

//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomizeColor.defaultBackgroundColor()
        self.genderSelector.delegate = self
        self.genderSelector.dataSource = self
        for tf in self.textFields {
            tf.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Button methods
    @IBAction func createUser(sender: UIButton) {
        self.createUser()
    }
    
    /**
     The property enable of all text fields becomes false
     */
    private func blockButtons() {
        self.nextButton.alpha = 0.4
        self.nextButton.enabled = false
        self.genderSelector.alpha = 0.4
        self.genderSelector.userInteractionEnabled = false
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        self.nextButton.alpha = 1
        self.nextButton.enabled = true
        self.genderSelector.alpha = 1
        self.genderSelector.userInteractionEnabled = true
    }

//MARK: GenderSelector DataSource and Delegate methods
    func genderWasSelected(gender: Gender) {
        self.gender = gender
        self.hideKeyboard()
    }

    func changeMaleLabel() -> String {
        return NSLocalizedString("PROF_GEN_MALE", comment: "Male")
    }
    
    func changeFemaleLabel() -> String {
        return NSLocalizedString("PROF_GEN_FEMALE", comment: "Female")
    }
    
//MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        //tests if next responder is nil
        guard let responder = nextResponder as? UITextField else {
            self.createUser()
            return false
        }
        
        //tests if next responder is empty
        if responder.text?.isEmpty == false {
            self.hideKeyboard()
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
//    private func checkIfEmpty() -> Bool {
//        for tf in self.textFields {
//            guard let txt = tf.text else {
//                return true
//            }
//            if txt.isEmpty {
//                return true
//            } else {
//                return false
//            }
//        }
//        return false
//    }
    
    private func checkIfEmpty() -> Bool {
        guard let name = self.nameTextField.text where !name.isEmpty else {
            let alert = DefaultAlerts.emptyField(NSLocalizedString("EMPTY_NAME", comment: ""), message: NSLocalizedString("EMPTY_FIELD_NAME", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        guard let surname = self.surnameTextField.text where !surname.isEmpty else {
            let alert = DefaultAlerts.emptyField(NSLocalizedString("EMPTY_SURNAME", comment: ""), message: NSLocalizedString("EMPTY_FIELD_SURNAME", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        guard let email = self.emailTextField.text where !email.isEmpty else {
            let alert = DefaultAlerts.emptyField(NSLocalizedString("EMPTY_EMAIL", comment: ""), message: NSLocalizedString("EMPTY_FIELD_EMAIL", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        if self.gender == nil {
            let alert = DefaultAlerts.emptyField(NSLocalizedString("EMPTY_GENDER", comment: ""), message: NSLocalizedString("EMPTY_FIELD_GENDER", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /**
     Hides the keyboard
     */
    private func hideKeyboard() {
        for tf in self.textFields {
            tf.resignFirstResponder()
        }
    }
    
//MARK: Create user method
    private func createUser() {
        self.hideKeyboard()
        //checks if there are empty data
        if !self.checkIfEmpty() {
            return
        }
        
        self.blockTextFields()
        self.blockButtons()
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        do {
            try AccountBO.createAccount(self.nameTextField.text!, surname: self.surnameTextField.text!, gender: self.gender!, email: self.emailTextField.text!, completionHandler: { (getAccount) in
                do {
                    //tries to create an account
                    try getAccount()
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("waitEmail", sender: self)
                } catch let internalError {
                    //TODO: handle error data threw by the server
                    guard let error = internalError as? ServerError else {
                        return
                    }
                    let title = NSLocalizedString("CREATE_NEW_USER_FAILED", comment: "")
                    let alert = DefaultAlerts.serverErrorAlert(error, title: title, customAction: nil)
                    self.activityIndicator.stopAnimating()
                    self.enableButtons()
                    self.enableTextFields()
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } catch {
            self.activityIndicator.stopAnimating()
            self.enableButtons()
            self.enableTextFields()
            let alertView = DefaultAlerts.invalidEmail()
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}
