//
//  RegisterStudentViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/7/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class RegisterStudentViewController: UIViewController, NinoImagePickerDelegate, NinoImagePickerDataSource {
    
//MARK: Outlets
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
//MARK: Variables
    let ninoImagePicker = NinoImagePicker()
    
    
//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        self.ninoImagePicker.delegate = self
        self.ninoImagePicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK: Button methods
    @IBAction func didTapProfilePicture(sender: UITapGestureRecognizer) {
        self.changeProfilePicture()
    }
    @IBAction func changeImageAction(sender: UIButton) {
        self.changeProfilePicture()
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
    
//MARK: Class methods
    private func changeProfilePicture() {
        self.ninoImagePicker.instantiateImagePicker(self)
    }

}
