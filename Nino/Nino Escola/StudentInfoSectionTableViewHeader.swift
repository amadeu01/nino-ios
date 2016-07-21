//
//  StudentInfoSectionTableViewHeader.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/20/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentInfoSectionTableViewHeader: UIView {


    @IBOutlet weak var editButton: UIButton! {
        didSet {
            //self.editButton.titleLabel!.text = "Editar"
            self.editButton.setTitle("Editar", forState: UIControlState.Normal)
            self.editButton.tintColor = CustomizeColor.whiteColor()
            self.editButton.setTitleColor(CustomizeColor.whiteColor(), forState: .Normal)
        }
    }
    @IBOutlet weak var pencilButton: UIButton! {
        didSet {
            var whitePencil = self.pencilButton.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
            self.pencilButton.imageView?.image = self.pencilButton.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate)
            pencilButton.imageView?.tintColor =  UIColor.whiteColor()
            self.pencilButton.setImage(whitePencil, forState: .Normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print("Awake from NIB")
    }
    class func instanceFromNib() -> UIView? {
        return UINib(nibName: "StudentInfoSectionTableViewHeader", bundle: nil).instantiateWithOwner(StudentInfoSectionTableViewHeader(), options: nil)[0] as? UIView
    }

}

//extension UIView {
//    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
//        return UINib(
//            nibName: nibNamed,
//            bundle: bundle
//            ).instantiateWithOwner(StudentInfoSectionTableViewHeader(), options: nil)[0] as? UIView
//    }
//}
