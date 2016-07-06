//
//  ManageEducatorsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/5/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManageEducatorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
@IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackgroundWithImage(UIImage(named: "backgroundBolas"))
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: TAbleView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == 0 {
            guard let newEducatorCell = tableView.dequeueReusableCellWithIdentifier("addNewEducator") else {
                print("Error inside ManageEducatorsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            newEducatorCell.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
            return newEducatorCell
        } else {
            guard let educatorCell = tableView.dequeueReusableCellWithIdentifier("educatorProfileTableViewCell") else {
                 print("Error inside ManageEducatorsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            educatorCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return educatorCell
        }
    }
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        print("willDisplayHeaderView")
//        
//        guard let view = view as? UITableViewHeaderFooterView  else {
//            return
//        }
//        
//        view.backgroundView!.backgroundColor = UIColor.clearColor()
//        
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView  = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 20))
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            // Configure add new educator cell
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            return 90
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            performSegueWithIdentifier("showRegisterNewEducatorViewController", sender: self)
        }
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
