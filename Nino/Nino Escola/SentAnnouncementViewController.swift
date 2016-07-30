//
//  SentAnnouncementViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/25/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
class SentAnnouncementViewController:UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewThatHoldsTextView: UIView!
    @IBOutlet weak var textView: UITextView!
    //    var text:String = ""
    //    var textTitle:String = ""
    
    var announcementText = ""
    var announcementTitle = ""
    var key = ""
    // boolean value that states whether the announcement was modified
    
    // Flag is set to true when user presses the trash. Therefore, if the user confirms the deletion
    //of a announcement, app will not attempt to auto-save the announcement when viewcontroller disappears.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Updates the title and text, if announcement has been edited in the past
        self.navigationItem.title = self.announcementTitle
        
        self.textView.text = self.announcementText
        
        self.navigationBarColor = CustomizeColor.clearBackgroundNino()
        
        //Scrollview always scrollable
        scrollView.alwaysBounceVertical = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
