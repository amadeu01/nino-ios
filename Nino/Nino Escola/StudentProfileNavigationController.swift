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
        performSegueWithIdentifier("label1", sender: self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (didPressToShowViewController1), name: "label1", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector (didPressToShowViewController2), name: "label2", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didPressToShowViewController3), name: "label3", object: nil)
        
        //TODO: remove observers when it's time
        
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPressToShowViewController1() {
        //
        performSegueWithIdentifier("label1", sender: self)
        print("didPressToShowViewController1")
        
    }
    func didPressToShowViewController2() {
        //
        performSegueWithIdentifier("label2", sender: self)
        print("didPressToShowViewController2")
    }
    func didPressToShowViewController3() {
        //
        performSegueWithIdentifier("label3", sender: self)
        print("didPressToShowViewController3")
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
