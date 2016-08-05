//
//  PhotoCollectionViewCell.swift
//  ninoEscola
//
//  Created by Danilo Becke on 28/10/15.
//  Copyright © 2015 Alfredo Cavalcante Neto. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var selectedIcon: UIImageView!
    var chose = false
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    func selectedToRemove(){
        self.chose = true
        self.photo.alpha = 0.6
        self.selectedIcon.alpha = 1
    }
    
    func deselect(){
        self.chose = false
        self.photo.alpha = 1
        self.selectedIcon.alpha = 0
    }
    
    func startIndicator(){
        self.indicator.center = self.contentView.center
        self.indicator.startAnimating()
        self.addSubview(self.indicator)
    }
    
    func stopIndicator(){
        self.indicator.stopAnimating()
        self.indicator.removeFromSuperview()
    }
    
}
