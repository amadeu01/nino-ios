//
//  StudentProfileNavigationController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/1/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegueWithIdentifier("showMyDayViewController", sender: self)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (didPressToShowMyDayViewController), name: "showMyDayViewController", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (didPressToShowActivitiesViewController), name: "showActivitiesViewController", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didPressToShowPhotosViewController), name: "showPhotosViewController", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didPressToShowChatViewController), name: "showChatViewController", object: nil)
        
        //TODO: remove observers when it's time
        
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPressToShowMyDayViewController() {
        performSegueWithIdentifier("showMyDayViewController", sender: self)
    }
    
    func didPressToShowActivitiesViewController() {
        performSegueWithIdentifier("showActivitiesViewController", sender: self)
    }
    
    func didPressToShowPhotosViewController() {
        performSegueWithIdentifier("showPhotosViewController", sender: self)
        
    }
    
    func didPressToShowChatViewController() {
        performSegueWithIdentifier("showChatViewController", sender: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
