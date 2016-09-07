//
//  GuardiansUpdateNameViewController.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 9/4/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class GuardiansUpdateNameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNinoDefaultBackGround()

        // Do any additional setup after loading the view.
    }
    
    private func hideKeyboard() {
        self.nameTextField.resignFirstResponder()
        self.surnameTextField.resignFirstResponder()
    }

    /**
     Checks if there are text fields without text
     
     - returns: true if there are
     */
    private func checkIfEmpty() -> Bool {
        if let txt = self.nameTextField.text {
            if txt.isEmpty {
                return true
            }
        } else {
            return true
        }
        if let txt = self.surnameTextField.text {
            if txt.isEmpty {
                return true
            }
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        //tests if next responder ir nil and is is empty
        guard let responder = nextResponder where (nextResponder as? UITextField)?.text?.isEmpty == true else {
            self.updateInfo()
            return false
        }

        responder.becomeFirstResponder()
        return false
    }
    
    @IBAction func confirmButtonPressed(sender: AnyObject) {
        self.updateInfo()
    }
    
    private func updateInfo() {
        self.hideKeyboard()
        //checks if there are empty data
        if self.checkIfEmpty() {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.confirmButton.enabled = false
        self.confirmButton.alpha = 0.4
        self.nameTextField.enabled = false
        self.nameTextField.alpha = 0.4
        self.surnameTextField.enabled = false
        self.surnameTextField.alpha = 0.4
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        GuardianBO.updateNameAndSurname(self.nameTextField.text!, surname: self.surnameTextField.text!) { (id) in
            self.confirmButton.enabled = true
            self.confirmButton.alpha = 1
            self.nameTextField.enabled = true
            self.nameTextField.alpha = 1
            self.surnameTextField.enabled = true
            self.surnameTextField.alpha = 1
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            do {
                try id()
                if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                    delegate.loggedIn = true
                    delegate.setupRootViewController(true)
                }
            } catch {
                let alert = DefaultAlerts.usedDidNotLoggedIn()
                self.presentViewController(alert, animated: true, completion: nil)
                //TODO handle error
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
