//
//  ManageStudentInfoViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/19/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManageStudentInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
            guard let newStudentCell = tableView.dequeueReusableCellWithIdentifier("guardianProfileTableViewCell") else {
                print("Error inside ManageStudentsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
        return UITableViewCell()
    }
    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {//Deletes the blank space below the cell
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
        let headerView  = UIView(frame: frame)
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            guard let guardianCell = cell as? GuardianTableViewCell else {
                return
            }
            //studentCell.configureCell(students[indexPath.row].name, profileImage: nil, index: indexPath.row
        
    }

}
