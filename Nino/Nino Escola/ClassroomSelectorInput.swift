//
//  ClassroomSelectorInput.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/26/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import TagListView

class ClassroomSelectorInput: UIView, TagListViewDelegate {

    @IBOutlet weak var tagListView: TagListView!{
        didSet{
            tagListView.delegate = self
            tagListView.textFont = UIFont.boldSystemFontOfSize(30)
            tagListView.textColor = CustomizeColor.lessStrongBackgroundNino()
            tagListView.borderColor = CustomizeColor.lessStrongBackgroundNino()
            tagListView.tagBackgroundColor = UIColor.whiteColor()
            //Selected
            tagListView.selectedTextColor = UIColor.whiteColor()
            tagListView.selectedBorderColor = CustomizeColor.lessStrongBackgroundNino()
            tagListView.tagSelectedBackgroundColor = CustomizeColor.lessStrongBackgroundNino()
            tagListView.backgroundColor = UIColor.clearColor()
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            tagListView.addTag("Hello, IT WORKS")
            print("TagView Did Set")
        }
    }
    //@IBOutlet weak var topTagList: TagListView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.tagListView.delegate = self
    }

    
    
    class func instanceFromNib() -> UIView? {
        return UINib(nibName: "ClassroomSelectorInput", bundle: nil).instantiateWithOwner(ClassroomSelectorInput(), options: nil)[0] as? UIView
    }
    

}
