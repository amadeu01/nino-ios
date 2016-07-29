//
//  MyDaySectionHeader.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/25/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// The header of a section in the MyDay, like Alimentation or Sleep
class MyDaySectionHeader: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    /**
     Sets the header, changing the image and text
     
     - parameter label: The title of the section
     - parameter icon:  The icon of the section
     
     - returns: Newly created MyDaySectionHeader
     */
    init(label: String, icon: MyDaySectionIcon) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let view = UINib(nibName: "MyDaySectionHeader", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        if let header = view {
            self.addSubview(header)
            header.frame = self.bounds
            
            self.label.text? = label
            
            self.icon.image = UIImage(named: icon.rawValue)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
