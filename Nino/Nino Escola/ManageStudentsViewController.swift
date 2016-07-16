//
//  ManageStudentsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/13/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

struct StudentMock{
    var name: String?
    var id: Int?
}
class ManageStudentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Define sections
    let studentSec = 0
    //Define global variables
    var students = [StudentMock]()
    var selectedStudentIndex = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNinoDefaultBackGround()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        students.append(StudentMock(name: "Miriam", id: 1))
        students.append(StudentMock(name: "Abélia", id: 2))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Novo Aluno", style: .Plain, target: self, action: #selector (didPressToAddNewNewStudent))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func didPressToAddNewNewStudent(){
        self.performSegueWithIdentifier("showRegisterStudentViewController", sender: self)
    }
    //MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == studentSec {
            return students.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == studentSec {
            guard let newStudentCell = tableView.dequeueReusableCellWithIdentifier("studentTableViewCell") else {
                print("Error inside ManageStudentsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            return newStudentCell
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
        if indexPath.section == studentSec {
            // Configure add new phase cell
            guard let studentCell = cell as? StudentTableViewCell else {
                return
            }
            studentCell.name = students[indexPath.row].name
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentSec {
            return 90
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentSec {
            return 90
        }
        return 0
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.section == studentSec {
//            self.selectedStudentIndex = indexPath.row
//            self.performSegueWithIdentifier("showRegisterStudentViewController", sender: self)
//        }
    }

    
    @IBAction func goBackToManageStudentsViewController(segue: UIStoryboardSegue) {
        
    }
    
}
