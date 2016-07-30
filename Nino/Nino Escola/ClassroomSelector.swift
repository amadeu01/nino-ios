//
//  ClassroomSelector.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/26/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ClassroomSelector: UIView {

    @IBOutlet weak var sample: UILabel!
    override var inputView: UIView? {
        return ClassroomSelectorInput.instanceFromNib()
    }
    
    override var inputAccessoryView: UIView? {
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(self.resignFirstResponder))
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolbar.items = [space, barButton]
        return toolbar
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    //MARK: View initialization
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let view = NSBundle.mainBundle().loadNibNamed("ClassroomSelector", owner: self, options: nil)[0] as? UIView
        if let dateSelctor = view {
            self.addSubview(dateSelctor)
            dateSelctor.frame = self.bounds
        }
    }
    
    @IBAction func userDidTap(sender: UITapGestureRecognizer) {
        self.becomeFirstResponder()
    }

}
