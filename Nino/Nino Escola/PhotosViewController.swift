//
//  PhotosViewController.swift
//  Nino
//
//  Created by Danilo Becke on 04/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController/*, UICollectionViewDelegate, UICollectionViewDataSource, NinoImagePickerDelegate, NinoImagePickerDataSource*/ {

    @IBOutlet weak var collectionView: UICollectionView!
    var photos = [UIImage]()
    var editionMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
//        self.collectionView.backgroundColor = CustomizeColor.clearColor()
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self
        
        //adding gesture recognizer to enter de edition mode
//        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"))
//        longPress.delegate = self
//        self.collectionView.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: CollectionView Methods
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.images.count + 1;
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        //displaying the pictures
//        if indexPath.row != 0{
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCollectionViewCell
//            if ((self.images[indexPath.row - 1] as! PhotoInfo).image) != nil{
//                cell.photo.image = (self.images[indexPath.row - 1] as! PhotoInfo).image!
//                cell.photo.clipsToBounds = true
//                cell.photo.layer.borderColor = CustomizeColor.lessStrongBackgroundNino().CGColor
//                cell.photo.layer.borderWidth = 1
//                cell.stopIndicator()
//            } else{
//                cell.startIndicator()
//            }
//            cell.deselect()
//            return cell
//            
//        }
//            //displaying the camera or the garbage
//        else{
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("addPhotos", forIndexPath: indexPath) as! AddPhotoCollectionViewCell
//            if self.editionMode{
//                cell.image.image = UIImage(named: "garbage")
//            }
//            else{
//                cell.image.image = UIImage(named: "camera")
//            }
//            return cell
//        }
//    }
//    
//    //MARK: NinoImagePicker methods
//    
//    func didFinishPickingImages(images: NSMutableArray) {
//        
//    }
//    
//    func allowsMultipleSelection() -> Bool {
//        return true
//    }
//    
//    func maximumNumberOfSelection() -> UInt {
//        return 10
//    }
//    
//    func showsNumberOfSelectedAssets() -> Bool {
//        return true
//    }
//    
//    func mustCropImage() -> Bool {
//        return false
//    }
//    
//    func imageTargetSize() -> CGSize {
//        //TODO: FIX
//        return CGSize(width: 10, height: 10)
//    }
//    
}
