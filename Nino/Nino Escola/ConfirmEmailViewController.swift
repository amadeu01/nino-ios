//
//  ConfirmEmailViewController.swift
//  Nino
//
//  Created by Danilo Becke on 04/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ConfirmEmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CustomizeColor.defaultBackgroundColor()
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("registerPasssword", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func validateEmail(token: String) {
        print(token)
    }
    
}
