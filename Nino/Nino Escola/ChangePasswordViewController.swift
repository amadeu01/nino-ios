//
//  ChangePasswordViewController.swift
//  Nino
//
//  Created by Danilo Becke on 11/10/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ChangePasswordViewController: DefaultChangePasswordViewController {
    @IBOutlet weak var schoolEmailTextField: UITextField!
    @IBOutlet weak var schoolActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var schoolChangePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField = self.schoolEmailTextField
        self.activityIndicator = schoolActivityIndicator
        self.changePasswordButton = schoolChangePasswordButton
        self.addNinoDefaultBackGround()
        if let txt = self.email {
            self.emailTextField?.text = txt
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changePasswordAction(sender: UIButton) {
    self.userDidTapToChangePassword { (success) in
        if success {
           self.performSegueWithIdentifier("unwindToLogin", sender: self)
        }
        }    }
}
