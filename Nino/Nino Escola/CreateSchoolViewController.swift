//
//  CreateSchoolViewController.swift
//  Nino
//
//  Created by Danilo Becke on 14/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class CreateSchoolViewController: UIViewController, GenderSelectorDelegate, GenderSelectorDataSource, UITextFieldDelegate {

//MARK: Outlets
    @IBOutlet weak var genderSelector: GenderSelector!
    @IBOutlet weak var schoolName: UITextField!
    @IBOutlet weak var schoolAddr: UITextField!
    @IBOutlet weak var educatorName: UITextField!
    @IBOutlet weak var educatorSurname: UITextField!
    @IBOutlet weak var educatorEmail: UITextField!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    
//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomizeColor.defaultBackgroundColor()
        self.genderSelector.delegate = self
        self.genderSelector.dataSource = self
        //redrawing the view
        self.genderSelector.setNeedsDisplay()
        
        for tf in self.textFields {
            tf.delegate = self
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: GenderSelector Delegate and DataSource Methods
    func genderWasSelected(gender: Gender) {
        print(gender)
    }
    
    func changeMaleLabel() -> String {
        return "Masculino"
    }
    
    func changeFemaleLabel() -> String {
        return "Feminino"
    }

//MARK: Button methods
    @IBAction func createUserAndSchool(sender: UIButton) {
    }
    
    /**
     The property enable of all text fields becomes false
     */
    private func blockButtons() {
        self.button.alpha = 0.4
        self.button.enabled = false
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        self.button.alpha = 1
        self.button.enabled = true
    }
    
//MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil) && (nextResponder as? UITextField)?.text?.isEmpty == true {
            nextResponder?.becomeFirstResponder()
        } else {
            self.hideKeyboard()
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
    
//MARK: Create user method
    private func createUser() {
        self.hideKeyboard()
        if self.checkIfEmpty() {
            self.emptyField()
        } else {
            self.blockTextFields()
            self.blockButtons()
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            
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

}
