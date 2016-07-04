//
//  RegisterPasswordViewController.swift
//  Nino
//
//  Created by Danilo Becke on 03/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController, UITextFieldDelegate {
    
//MARK: Outlets
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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
        //TODO: Server integration
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("createSchool", sender: nil)
        }
    }

}
