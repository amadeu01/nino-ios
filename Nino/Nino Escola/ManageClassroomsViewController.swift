//
//  ManageClassroomsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/8/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManageClassroomsViewController: UINavigationController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        tableView.backgroundColor = UIColor.clearColor()
        //tableView.tableFooterView?.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView Data Source
    
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
            guard let newClassroomCell = tableView.dequeueReusableCellWithIdentifier("addNewClassroom") else {
                print("Error inside ManageClassroomsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            newClassroomCell.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
            return newClassroomCell
        } else {
            guard let classroomCell = tableView.dequeueReusableCellWithIdentifier("clasroomProfileTableViewCell") else {
                print("Error inside ManageClassroomsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            classroomCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return classroomCell
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
            // TODO: Configure add new classroom cell
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
            performSegueWithIdentifier("showRegisterNewClassroomViewController", sender: self)
            
        } else {
            self.performSegueWithIdentifier("showClassroomProfileViewController", sender: self)
        }
    }
    
    
    // MARK: Navigation
    
    @IBAction func cancelRegisterNewEducator(segue: UIStoryboardSegue) {
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
