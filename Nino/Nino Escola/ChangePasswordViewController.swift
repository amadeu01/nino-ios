//
//  ChangePasswordViewController.swift
//  Nino
//
//  Created by Danilo Becke on 11/10/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var email: String?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        if let txt = self.email {
            self.emailTextField.text = txt
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePasswordAction(sender: UIButton) {
        self.emailTextField.resignFirstResponder()
        guard let user = self.emailTextField.text else {
            //TODO: empty email
            return
        }
        self.changePasswordButton.userInteractionEnabled = false
        self.changePasswordButton.alpha = 0.4
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        do {
            try AccountBO.changePassword(user, completionHandler: { (change) in
                do {
                    try change()
                    //TODO: alert -> login
                } catch {
                    //TODO: email not found
                }
            })
        } catch {
            self.changePasswordButton.userInteractionEnabled = true
            self.changePasswordButton.alpha = 1
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            //TODO: invalid email
        }
    }
    
}
