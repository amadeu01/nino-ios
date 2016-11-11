//
//  DefaultChangePasswordViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 01/11/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class DefaultChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField?
    var email: String?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var changePasswordButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func userDidTapToChangePassword(completionHandler: (success:Bool) -> Void) {
        guard let thisEmailTextField = emailTextField else {
            return
        }
        guard let thisActivityIndicator = activityIndicator else {
            return
        }
        guard let thisChangePasswordButton = changePasswordButton else {
            return
        }
        thisEmailTextField.resignFirstResponder()
        let alertView = UIAlertController(title: "Erro", message: nil , preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        guard let user = thisEmailTextField.text else {
            alertView.message =  "Por favor digite um e-mail válido"
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            completionHandler(success: false)
            return
        }
        thisChangePasswordButton.userInteractionEnabled = false
        thisChangePasswordButton.alpha = 0.4
        thisActivityIndicator.startAnimating()
        thisActivityIndicator.hidden = false
        do {
            try AccountBO.changePassword(user, completionHandler: { (change) in
                do {
                    try change()
                    alertView.title = "Sucesso!"
                    alertView.message = "Um e-mail foi enviado para o endereço \(user) com as instruções para o registro de uma nova senha."
                    let okGoBackAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                        //self.performSegueWithIdentifier("unwindToLogin", sender: self)
                        completionHandler(success: true)
                    })
                    alertView.addAction(okGoBackAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                } catch {
                    alertView.message = "Não foi encontrada nenhuma conta com o e-mail \(user)"
                    let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    thisChangePasswordButton.userInteractionEnabled = true
                    thisChangePasswordButton.alpha = 1
                    thisActivityIndicator.stopAnimating()
                    thisActivityIndicator.hidden = true
                    completionHandler(success: false)
                }
            })
        } catch {
            alertView.message = "Por favor digite um e-mail válido"
            alertView.addAction(okAction)
            thisChangePasswordButton.userInteractionEnabled = true
            thisChangePasswordButton.alpha = 1
            thisActivityIndicator.stopAnimating()
            thisActivityIndicator.hidden = true
            self.presentViewController(alertView, animated: true, completion: nil)
            completionHandler(success: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
