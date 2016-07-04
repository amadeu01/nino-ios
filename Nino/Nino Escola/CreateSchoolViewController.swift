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

class CreateSchoolViewController: UIViewController, UITextFieldDelegate, QBImagePickerControllerDelegate, TOCropViewControllerDelegate {
    
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
    
//MARK: Variables
    //FIXME: change button labels to localized strings
    var qbImagePickerController: QBImagePickerController?
    
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
    
//MARK: QBImagePicker methods
    /**
     Instantiates one new imagePicker
     */
    private func setupImagePicker() {
        self.qbImagePickerController = QBImagePickerController()
        guard let imagePicker = self.qbImagePickerController else {
            return
        }
        imagePicker.delegate = self
        imagePicker.allowsMultipleSelection = true
        imagePicker.maximumNumberOfSelection = 1
        imagePicker.showsNumberOfSelectedAssets = false
        imagePicker.mediaType = QBImagePickerMediaType.Image
    }
    
    private func changeIcon() {
        self.setupImagePicker()
        guard let imagePicker = self.qbImagePickerController else {
            return
        }
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /**
     Delegate method called when the user cancels the selection
     
     */
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Delegate method called when the user finishes the selection
     
     */
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        guard let asset = assets[0] as? PHAsset else {
            return
        }
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        self.presentCropViewController(self.getImageFromAsset(asset))
    }
    
    /**
     Gets one asset and returns their image
     
     - parameter asset: original asset
     
     - returns: UIImage
     */
    private func getImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: self.logoImageView.frame.width, height: self.logoImageView.frame.height), contentMode: .AspectFit, options: option, resultHandler: {(result, info) -> Void in
            guard let img = result else {
                return
            }
            image = img
        })
        return image
    }
    
//MARK: TOCropViewController methods
    /**
     Presents TOCropViewController for crop the image
     
     - parameter image: image to be cropped
     */
    func presentCropViewController(image: UIImage) {
        let toCropViewController = TOCropViewController(image: image)
        toCropViewController.delegate = self
        toCropViewController.defaultAspectRatio = TOCropViewControllerAspectRatio.RatioSquare
        presentViewController(toCropViewController, animated: true, completion: nil)
    }
    
    /**
     Delegate method called when the user finishes to crop the image
     
     */
    func cropViewController(cropViewController: TOCropViewController!, didCropToImage image: UIImage!, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismissViewControllerAnimated(true, completion: nil)
        self.logoImageView.image = image
    }
    
//MARK: Create School method
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
            //gets the current user
            guard let educator = NinoSession.sharedInstance.educator else {
                self.activityIndicator.stopAnimating()
                self.enableButtons()
                self.enableTextFields()
                let alertView = DefaultAlerts.usedDidNotLoggedIn(self)
                self.presentViewController(alertView, animated: true, completion: nil)
                return
            }
            var image: NSData? = nil
            //FIXME: change placeholder image for the correct image (waiting Camila)
            let placeholderImage = UIImageJPEGRepresentation(UIImage(named: "Logo-Nino")!, 1.0)
            let schoolImage = UIImageJPEGRepresentation(self.logoImageView.image!, 1.0)
            //checks if the user changes the image
            if let imageBefore = placeholderImage {
                if let newImage = schoolImage {
                    if !imageBefore.isEqualToData(newImage) {
                        image = NSData(data: newImage)
                    }
                }
            }
            try SchoolBO.createSchool(self.schoolNameTextField.text!, address: self.addressTextField.text!, cnpj: nil, telephone: self.phoneTextField.text!, email: educator.email, owner: educator.id, logo: image, phases: nil, educators: nil, students: nil, menus: nil, activities: nil, calendars: nil) { (getSchool) in
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
}
