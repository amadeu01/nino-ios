//
//  ProfileTopBarViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/1/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ProfileTopBarViewController: UIViewController {
    weak var delegate: StudentProfileNavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func showMyDayViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showMyDayViewController", object: self)
    }
    @IBAction func showActivitiesViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showActivitiesViewController", object: self)
    }
    @IBAction func showPhotosViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showPhotosViewController", object: self)
    }
    @IBAction func showChatViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showChatViewController", object: self)
    }
    
    
   
    
    
}