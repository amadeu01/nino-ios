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
    @IBAction func shouldPresentViewController1(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("label1", object: self)
        
    }
    
    @IBAction func shouldPresentViewController2(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("label2", object: self)
    }
    @IBAction func shouldPresentViewController3(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("label3", object: self)
    }
}


