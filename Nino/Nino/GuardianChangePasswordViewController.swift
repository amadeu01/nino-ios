//
//  GuardianChangePasswordViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 31/10/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class GuardianChangePasswordViewController: DefaultChangePasswordViewController {

    @IBOutlet weak var guardianEmailTextField: UITextField!
    @IBOutlet weak var guardianActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var guadianChangePasswordButton: UIButton!
    
    override func viewDidLoad() {
        self.guadianChangePasswordButton.layer.cornerRadius = 5
        super.viewDidLoad()
        self.emailTextField = self.guardianEmailTextField
        self.activityIndicator = guardianActivityIndicator
        self.changePasswordButton = guadianChangePasswordButton
        self.addNinoDefaultBackGround()
        if let txt = self.email {
            self.emailTextField?.text = txt
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func userDidTapToChangeGuardianPassword(sender: AnyObject) {
        self.userDidTapToChangePassword { (success) in
            if success {
                self.performSegueWithIdentifier("unwindToLogin", sender: self)
            }
        }
    }
}
