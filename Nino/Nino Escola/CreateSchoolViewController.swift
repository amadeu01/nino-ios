//
//  CreateSchoolViewController.swift
//  Nino
//
//  Created by Danilo Becke on 30/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class CreateSchoolViewController: UIViewController, UITextFieldDelegate {
    
//MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var changeLogoButton: UIButton!
    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomizeColor.defaultBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Button methods
    /**
     The property enable of all text fields becomes false
     */
    private func blockButtons() {
        for button in self.buttons {
            button.enabled = false
            button.alpha = 0.4
        }
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        for button in self.buttons {
            button.enabled = true
            button.alpha = 1
        }
    }
    
//MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        //tests if next responder ir nil and is is empty
        guard let responder = nextResponder where (nextResponder as? UITextField)?.text?.isEmpty == true else {
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

}
