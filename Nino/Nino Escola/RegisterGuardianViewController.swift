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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Adicionar Responsável"
        self.addNinoDefaultBackGround()
        for tf in self.textFields {
            tf.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .Plain, target: self, action: #selector (didPressToCancel))
    }
    
    func didPressToCancel(){
        performSegueWithIdentifier("goBackToManageStudentInfoViewController", sender: self)
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
