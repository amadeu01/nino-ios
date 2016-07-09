//
//  NinoImagePicker.swift
//  Nino
//
//  Created by Danilo Becke on 08/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import QBImagePickerController
import TOCropViewController

class NinoImagePicker: NSObject, QBImagePickerControllerDelegate, TOCropViewControllerDelegate {
    
//MARK: Delegate and DataSource
    var delegate: NinoImagePickerDelegate?
    var dataSource: NinoImagePickerDataSource? {
        didSet {
            self.configureDataSource()
        }
    }
    
//MARK: Private variables
    private var allowsMultipleSelection: Bool
    private var maximumNumberOfSelection: UInt
    private var showsNumberOfSelectedAssets: Bool
    private var imageTargetSize: CGSize
    private var mustCropImage: Bool
    
    private var viewController: UIViewController?
    
//MARK: DataSource Setup
    private func configureDataSource() {
        if let allowsMultipleSelection = dataSource?.allowsMultipleSelection() {
            self.allowsMultipleSelection = allowsMultipleSelection
        }
        if let maximumNumberOfSelection = dataSource?.maximumNumberOfSelection() {
            self.maximumNumberOfSelection = maximumNumberOfSelection
        }
        if let showsNumberOfSelectedAssets = dataSource?.showsNumberOfSelectedAssets() {
            self.showsNumberOfSelectedAssets = showsNumberOfSelectedAssets
        }
        if let imageTargetSize = dataSource?.imageTargetSize() {
            self.imageTargetSize = imageTargetSize
        }
        if let mustCropImage = dataSource?.mustCropImage() {
            self.mustCropImage = mustCropImage
        }
    }
    
//MARK: Init
    override init() {
        self.allowsMultipleSelection = true
        self.mustCropImage = false
        self.imageTargetSize = CGSize(width: 300, height: 300)
        self.showsNumberOfSelectedAssets = true
        self.maximumNumberOfSelection = 10
        super.init()
    }
    
//MARK: Public methods
    /**
     Instantiate a new NinoImagePicker
     
     - parameter viewController: Parent view controller
     */
    func instantiateImagePicker(viewController: UIViewController) {
        self.viewController = viewController
        let qbImagePicker = self.setupImagePicker()
        self.viewController?.presentViewController(qbImagePicker, animated: true, completion: nil)
    }
    
//MARK: QBImagePicker methods
    /**
     Instantiates one new imagePicker
     
     - returns: QBImagePicker
     */
    private func setupImagePicker() -> QBImagePickerController {
        let qbImagePickerController = QBImagePickerController()
        qbImagePickerController.delegate = self
        qbImagePickerController.allowsMultipleSelection = self.allowsMultipleSelection
        qbImagePickerController.maximumNumberOfSelection = self.maximumNumberOfSelection
        qbImagePickerController.showsNumberOfSelectedAssets = self.showsNumberOfSelectedAssets
        qbImagePickerController.mediaType = QBImagePickerMediaType.Image
        return qbImagePickerController
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
        let selectedImages = NSMutableArray()
        for asset in assets {
            guard let img = asset as? PHAsset else {
                continue
            }
            selectedImages.addObject(self.getImageFromAsset(img))
        }
        
        if self.mustCropImage && self.maximumNumberOfSelection < 2 {
            if let image = selectedImages.firstObject as? UIImage {
                self.viewController?.presentViewController(self.presentCropViewController(image), animated: true, completion: nil)
            }
        } else {
            delegate?.didFinishPickingImages(selectedImages)
        }
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
        manager.requestImageForAsset(asset, targetSize: self.imageTargetSize, contentMode: .AspectFit, options: option, resultHandler: {(result, info) -> Void in
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
    private func presentCropViewController(image: UIImage) -> TOCropViewController {
        let toCropViewController = TOCropViewController(image: image)
        toCropViewController.delegate = self
        toCropViewController.defaultAspectRatio = TOCropViewControllerAspectRatio.RatioSquare
        return toCropViewController
    }
    
    /**
     Delegate method called when the user finishes to crop the image
     
     */
    func cropViewController(cropViewController: TOCropViewController!, didCropToImage image: UIImage!, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismissViewControllerAnimated(true, completion: nil)
        let images = NSMutableArray()
        images.addObject(image)
        delegate?.didFinishPickingImages(images)
    }
    
}

protocol NinoImagePickerDelegate {
    /**
     Delegate method called when the image is selected
     
     - parameter images: NSMutableArray of UIImage
     */
    func didFinishPickingImages(images: NSMutableArray)
}

protocol NinoImagePickerDataSource {
    /**
     The image picker allow multiple selections?
     
     - returns: Bool
     */
    func allowsMultipleSelection() -> Bool
    /**
     Maximum number of images to be selected
     
     - returns: UInt
     */
    func maximumNumberOfSelection() -> UInt
    /**
     Must image picker show the number of selected images?
     
     - returns: Bool
     */
    func showsNumberOfSelectedAssets() -> Bool
    /**
     Must image picker let crop the image after selection?
     
     - returns: Bool
     */
    func mustCropImage() -> Bool
    /**
     Size of the UIImageView which will contain the final images
     
     - returns: CGSize
     */
    func imageTargetSize() -> CGSize
}
