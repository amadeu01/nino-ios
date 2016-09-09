//
//  RegisterGuardianViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/22/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class RegisterGuardianViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addGuardianButton: UIButton!
    
    var studentID: String?
    private var guardian: Guardian?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("PROF_ADD_GUARDIAN", comment: "Add Guardian")
        self.addNinoDefaultBackGround()
        for tf in self.textFields {
            tf.delegate = self
        }
        if self.studentID == nil {
            performSegueWithIdentifier("goBackToManageStudentInfoViewController", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Plain, target: self, action: #selector (didPressToCancel))
    }
    
    func didPressToCancel() {
        performSegueWithIdentifier("goBackToManageStudentInfoViewController", sender: self)
    }

    /**
     The property enable of all text fields becomes false
     */
    private func blockButtons() {
        self.addGuardianButton.enabled = false
        self.addGuardianButton.alpha = 0.4
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        self.addGuardianButton.enabled = true
        self.addGuardianButton.alpha = 1
    }
    
    //MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        //tests if next responder is nil
        guard let responder = nextResponder as? UITextField else {
            self.addGuardian()
            return false
        }
        
        //tests if next responder is empty
        if responder.text?.isEmpty == false {
            self.addGuardian()
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
    
    @IBAction func registerGuardianAction(sender: UIButton) {
        self.addGuardian()
    }
    
//MARK: Class methods
    private func addGuardian() {
        self.hideKeyboard()
        if self.checkIfEmpty() {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.blockButtons()
        self.blockTextFields()
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        do {
            try GuardianBO.createGuardian(self.nameTextField.text!, surname: self.surnameTextField.text!, email: self.emailTextField.text!, studentID: self.studentID!) { (guardian) in
                do {
                    self.guardian = try guardian()
                    self.performSegueWithIdentifier("goBackToManageStudentInfoViewController", sender: self)
                } catch let error {
                    //TODO: handle error
                    NinoSession.sharedInstance.kamikaze(["error":error, "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                }
            }
        } catch {
            self.activityIndicator.stopAnimating()
            self.enableButtons()
            self.enableTextFields()
            let alertView = DefaultAlerts.invalidEmail()
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goBackToManageStudentInfoViewController" {
            let dest = segue.destinationViewController as? ManageStudentInfoViewController
            if let manageStudent = dest {
                if self.guardian != nil {
                manageStudent.mustReloadGuardians = true
                manageStudent.guardians.append(self.guardian!)
                }
            }
        }
    }

}
