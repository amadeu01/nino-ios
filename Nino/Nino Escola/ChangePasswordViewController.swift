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
        let alertView = UIAlertController(title: "Erro", message: nil , preferredStyle: .Alert)
         let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        guard let user = self.emailTextField.text else {
            alertView.message =  "Por favor digite um e-mail válido"
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
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
                    alertView.title = "Sucesso!"
                    alertView.message = "Um e-mail foi enviado para o endereço \(user) com as instruções para o registro de uma nova senha."
                    let okGoBackAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                        self.performSegueWithIdentifier("unwindToLogin", sender: self)
                    })
                    alertView.addAction(okGoBackAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                } catch {
                    //TODO: email not found. SERVER is not returning error for an unregistered email.
                    alertView.message = "Não foi encontrada nenhuma conta com o e-mail \(user)"
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            })
        } catch {
            alertView.message = "Por favor digite um e-mail válido"
            //let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            self.changePasswordButton.userInteractionEnabled = true
            self.changePasswordButton.alpha = 1
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
            //TODO: invalid email
        }
    }
    
}
