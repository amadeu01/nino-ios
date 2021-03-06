//
//  RegisterStudentViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/7/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class RegisterStudentViewController: UIViewController, NinoImagePickerDelegate, NinoImagePickerDataSource, GenderSelectorDelegate, UITextFieldDelegate {
    
//MARK: Outlets
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var genderSelector: GenderSelector!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
//MARK: Variables
    private let ninoImagePicker = NinoImagePicker()
    private var gender: Gender?
    private let datePicker = UIDatePicker()
    private let dateFormatter = NSDateFormatter()
    var roomID: String?
    private var student: Student?
    
//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        self.ninoImagePicker.delegate = self
        self.ninoImagePicker.dataSource = self
        self.genderSelector.delegate = self
        for tf in self.textFields {
            tf.delegate = self
        }
        self.datePicker.datePickerMode = .Date
        self.datePicker.maximumDate = NSDate()
        self.birthDateTextField.inputView = datePicker
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.hideKeyboard))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolbar.items = [space, barButton]
        self.birthDateTextField.inputAccessoryView = toolbar
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker), forControlEvents: .ValueChanged)
//        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.dateFormatter.dateStyle = .ShortStyle
        
        if self.roomID == nil {
            performSegueWithIdentifier("goBackToManageStudentsViewController", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Plain, target: self, action: #selector (didPressToCancel))
    }
    
    func didPressToCancel() {
        performSegueWithIdentifier("goBackToManageStudentsViewController", sender: self)
    }
    
//MARK: Button methods
    @IBAction func didTapProfilePicture(sender: UITapGestureRecognizer) {
        self.changeProfilePicture()
    }
    
    @IBAction func changeImageAction(sender: UIButton) {
        self.changeProfilePicture()
    }
    
    @IBAction func registerStudentAction(sender: UIButton) {
        self.registerStudent()
    }
    
    @objc private func handleDatePicker() {
        self.birthDateTextField.text = self.dateFormatter.stringFromDate(self.datePicker.date)
    }
    
    /**
     The property enable of all text fields becomes false
     */
    private func blockButtons() {
        for btn in self.buttons {
            btn.alpha = 0.4
            btn.enabled = false
        }
        self.genderSelector.alpha = 0.4
        self.genderSelector.userInteractionEnabled = false
        self.profilePictureImageView.alpha = 0.4
        self.profilePictureImageView.userInteractionEnabled = false
    }
    
    /**
     The property enable of all text fields becomes true
     */
    private func enableButtons() {
        for btn in self.buttons {
            btn.alpha = 1
            btn.enabled = true
        }
        self.genderSelector.alpha = 1
        self.genderSelector.userInteractionEnabled = true
        self.profilePictureImageView.alpha = 1
        self.profilePictureImageView.userInteractionEnabled = true
    }
    
//MARK: TextField methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        //tests if next responder is nil
        guard let responder = nextResponder as? UITextField else {
            self.registerStudent()
            return false
        }
        
        //tests if next responder is empty
        if responder.text?.isEmpty == false {
            self.registerStudent()
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
    @objc private func hideKeyboard() {
        for tf in self.textFields {
            tf.resignFirstResponder()
        }
    }
    
//MARK: NinoImagePicker methods
    func didFinishPickingImages(images: NSMutableArray) {
        let image = images.firstObject as? UIImage
        self.profilePictureImageView.image = image
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
        return CGSize(width: self.profilePictureImageView.frame.width, height: self.profilePictureImageView.frame.height)
    }
    
//MARK: GenderSelector methods
    func genderWasSelected(gender: Gender) {
        self.hideKeyboard()
        self.gender = gender
    }
    
//MARK: Class methods
    private func changeProfilePicture() {
        self.ninoImagePicker.instantiateImagePicker(self)
    }

    private func registerStudent() {
        self.hideKeyboard()
        //checks if there are empty data
        guard let userGender = self.gender where self.checkIfEmpty() == false else {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let birthDate = self.dateFormatter.dateFromString(self.birthDateTextField.text!)
        guard let birthday = birthDate else {
            let alert = DefaultAlerts.emptyField()
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        self.blockTextFields()
        self.blockButtons()
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        var image: NSData? = nil
        let placeholderImage = UIImageJPEGRepresentation(UIImage(named: "Becke_Adicionar-bebe")!, 1.0)
        let profileImage = UIImageJPEGRepresentation(self.profilePictureImageView.image!, 1.0)
        //checks if the user changed the image
        if let imageBefore = placeholderImage {
            if let newImage = profileImage {
                if !imageBefore.isEqualToData(newImage) {
                    image = NSData(data: newImage)
                }
            }
        }
        StudentBO.createStudent(self.roomID!, name: self.nameTextField.text!, surname: self.surnameTextField.text!, birthDate: birthday, gender: userGender, profilePictue: image) { (student) in
            do {
                let newStudent = try student()
                self.student = newStudent
                self.performSegueWithIdentifier("goBackToManageStudentsViewController", sender: self)
            } catch let error {
                //TODO: handle error
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goBackToManageStudentsViewController" {
            let dest = segue.destinationViewController as? ManageStudentsViewController
            if let manageStudents = dest {
                if self.student != nil {
                    manageStudents.mustRealoadData = true
                    manageStudents.students.append(self.student!)
                }
            }
        }
    }
}
