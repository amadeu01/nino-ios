//
//  CreateSchoolViewController.swift
//  Nino
//
//  Created by Danilo Becke on 30/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import QBImagePickerController
import TOCropViewController

class CreateSchoolViewController: UIViewController, UITextFieldDelegate, NinoImagePickerDelegate, NinoImagePickerDataSource {
    
//MARK: Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var changeLogoButton: UIButton!
    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: Variables
    let ninoImagePicker = NinoImagePicker()
    
//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomizeColor.defaultBackgroundColor()
        //set border at the imageView
        self.logoImageView.layer.borderWidth = 1
        self.logoImageView.layer.borderColor = CustomizeColor.lessStrongBackgroundNino().CGColor
        
        for tf in self.textFields {
            tf.delegate = self
        }
        
        self.ninoImagePicker.delegate = self
        self.ninoImagePicker.dataSource = self
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
        self.logoImageView.userInteractionEnabled = false
        self.logoImageView.alpha = 0.4
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        for button in self.buttons {
            button.enabled = true
            button.alpha = 1
        }
        self.logoImageView.userInteractionEnabled = true
        self.logoImageView.alpha = 1
    }
    
    @IBAction func changeIconAction(sender: UIButton) {
        self.changeIcon()
    }
    
    @IBAction func didTapLogo(sender: UITapGestureRecognizer) {
        self.changeIcon()
    }
    
    @IBAction func createSchoolAction(sender: UIButton) {
        self.createSchool()
    }
    
    @IBAction func backToLoginAction(sender: UIButton) {
        self.segueToLogin()
    }
    
//MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        //tests if next responder ir nil and is is empty
        guard let responder = nextResponder where (nextResponder as? UITextField)?.text?.isEmpty == true else {
            self.createSchool()
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
    
//MARK: NinoImagePicker delegate and datasource methods
    func didFinishPickingImages(images: NSMutableArray) {
        let image = images.firstObject as? UIImage
        self.logoImageView.image = image
    }
    
    func allowsMultipleSelection() -> Bool {
        return true
    }
    
    func maximumNumberOfSelection() -> UInt {
        return 1
    }
    
    func showsNumberOfSelectedAssets() -> Bool {
        return false
    }
    
    func mustCropImage() -> Bool {
        return true
    }
    
    func imageTargetSize() -> CGSize {
        return CGSize(width: self.logoImageView.frame.width, height: self.logoImageView.frame.height)
    }
    
    
//MARK: Class methods
    private func changeIcon() {
        self.ninoImagePicker.instantiateImagePicker(self)
    }
    
    private func createSchool() {
        self.hideKeyboard()
        //checks if there are empty data
        if self.checkIfEmpty() {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.blockTextFields()
        self.blockButtons()
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        do {
//            gets the current user credential
            guard let credential = NinoSession.sharedInstance.credential else {
                self.activityIndicator.stopAnimating()
                self.enableButtons()
                self.enableTextFields()
                let alertView = DefaultAlerts.usedDidNotLoggedIn()
                self.presentViewController(alertView, animated: true, completion: nil)
                return
            }
            var image: NSData? = nil
            //FIXME: change placeholder image for the correct image (waiting Camila)
//            let placeholderImage = UIImageJPEGRepresentation(UIImage(named: "Logo-Nino")!, 1.0)
//            let schoolImage = UIImageJPEGRepresentation(self.logoImageView.image!, 1.0)
            let placeholderImage = UIImagePNGRepresentation(UIImage(named: "Logo-Nino")!)
            let schoolImage = UIImagePNGRepresentation(self.logoImageView.image!)
            //checks if the user changed the image
            if let imageBefore = placeholderImage {
                if let newImage = schoolImage {
                    if !imageBefore.isEqualToData(newImage) {
                        image = NSData(data: newImage)
                    }
                }
            }
            try SchoolBO.createSchool(credential.token, name: self.schoolNameTextField.text!, address: self.addressTextField.text!, cnpj: nil, telephone: self.phoneTextField.text!, email: self.emailTextField.text!, owner: nil, logo: image, phases: nil, educators: nil, students: nil, menus: nil, activities: nil, calendars: nil) { (getSchool) in
                do {
                    let school = try getSchool()
                    NinoSession.sharedInstance.setSchool(school)
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.activityIndicator.stopAnimating()
                        //changes the view
                        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                            delegate.loggedIn = true
                            delegate.setupRootViewController(true)
                        }
                    })
                } catch let internalError {
                    //TODO: handle error
                }
            }
        } catch _ {
            self.activityIndicator.stopAnimating()
            self.enableButtons()
            self.enableTextFields()
            let alertView = DefaultAlerts.invalidEmail()
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
//MARK: Segue Methods
    private func segueToLogin() {
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.loggedIn = false
            delegate.setupRootViewController(true)
        }
    }
}
