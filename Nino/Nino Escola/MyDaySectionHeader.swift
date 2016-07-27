//
//  MyDaySectionHeader.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 7/25/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class MyDaySectionHeader: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    init(label: String, icon: MyDaySectionIcon) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        let view = UINib(nibName: "MyDaySectionHeader", bundle: nil).instantiateWithOwner(self, options: nil)[0] as? UIView
        if let header = view {
            self.addSubview(header)
            header.frame = self.bounds
            
            self.label.text? = label
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
