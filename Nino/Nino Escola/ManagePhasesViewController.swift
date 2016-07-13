//
//  ManagePhasesViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/13/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManagePhasesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: TAbleView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {// Add new Phase
            return 1
        }
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == 1 {
            guard let newPhaseCell = tableView.dequeueReusableCellWithIdentifier("addNewPhase") else {
                print("Error inside ManagePhasesViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            newPhaseCell.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
            return newPhaseCell
        } else {
            guard let phaseCell = tableView.dequeueReusableCellWithIdentifier("phaseProfileTableViewCell") else {
                print("Error inside ManagePhasesViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            phaseCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return phaseCell
        }
    }
    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
        
        let headerView  = UIView(frame: frame)
        
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            // Configure add new phase cell
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
        if indexPath.section == 0 {
            performSegueWithIdentifier("showRegisterNewPhaseViewController", sender: self)
            
        } else {
            self.performSegueWithIdentifier("showPhaseProfileViewController", sender: self)
        }
    }
    
    
    // MARK: Navigation
    
    @IBAction func cancelRegisterNewPhase(segue: UIStoryboardSegue) {
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        
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
