//
//  ManageStudentsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/13/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManageStudentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Define sections
    let studentSec = 0
    let classroomInfoSec = 1
    let classroomDeleteSec = 2
    //Define global variables
    var students = [Student]()
    var selectedStudentIndex = 0
    var roomID: String?
    var mustRealoadData = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNinoDefaultBackGround()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        
        NinoNotificationManager.sharedInstance.addObserverForStudentsUpdates(self, selector: #selector(studentsUpdated))
        
        self.updateData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("STU_NEW", comment: "New Student"), style: .Plain, target: self, action: #selector (didPressToAddNewNewStudent))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func studentsUpdated(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            //TODO: Unexpected case
            return
        }
        if let error = userInfo["error"] {
            //TODO: handle error
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newStudents = message.dataToInsert as? [Student] {
                for student in newStudents {
                    self.students.append(student)
                }
                self.tableView.reloadData()
            }
            //TODO: updated students
            //TODO: deleted students
        }
    }
    
    func updateData() {
        guard let room = self.roomID else {
            //TODO: back to phases
            return
        }
        StudentBO.getStudent(room) { (students) in
            do {
                let localStudents = try students()
                for student in localStudents {
                    self.students.append(student)
                }
                self.tableView.reloadData()
            } catch {
                //TODO: getStudents error
            }
        }
    }

    func didPressToAddNewNewStudent() {
        self.performSegueWithIdentifier("showRegisterStudentViewController", sender: self)
    }
    func didPressToDeleteClassroom() {
        let alert = UIAlertController(title: "Deletar Turma", message: "Deseja deletar a turma \(self.title!)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let deleteAction = UIAlertAction(title: NSLocalizedString("GENERAL_DELETE", comment: "Delete"), style: .Destructive) { (alert) in
            //TODO: delete room
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func didPressToChangeClassroomName() {
        let alert = UIAlertController(title: "Alterar o nome da turma", message: "Digite um novo nome para a turma \(self.title!)", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.text = self.title
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let changeAction = UIAlertAction(title: "Alterar", style: .Default) { (alert) in
            //TODO: Create New phase
        }
        alert.addAction(cancelAction)
        alert.addAction(changeAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    //MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == studentSec {
            return students.count
        } else if section == classroomInfoSec {
            return 1
        } else if section == classroomDeleteSec {
            return 1
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
        } else if indexPath.section == classroomInfoSec {
            guard let infoCell = tableView.dequeueReusableCellWithIdentifier("nameOfTheClassroomCell") else {
                return UITableViewCell(style: .Value1, reuseIdentifier: "nameOfTheClassroomCell")
            }
            return infoCell
        } else if indexPath.section == classroomDeleteSec {
            guard let deleteCell = tableView.dequeueReusableCellWithIdentifier("deleteClassroomCell") else {
                return UITableViewCell(style: .Default, reuseIdentifier: "deleteClassroomCell")
            }
            return deleteCell
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
            studentCell.configureCell(students[indexPath.row].name, profileImage: nil, index: indexPath.row)
        } else if indexPath.section == classroomInfoSec {
            // configure info cell
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = self.title
                cell.textLabel?.text = NSLocalizedString("PROF_NAME", comment: "Name")
            }
        } else if indexPath.section == classroomDeleteSec {
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("GENERAL_DELETE", comment: "Delete") + " " + self.title!
                cell.textLabel?.textColor = UIColor.redColor()
            }
        }
        
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentSec {
            return 90
        }
        return 70
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentSec {
            return 90
        }
        return 70
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == studentSec {
            self.selectedStudentIndex = indexPath.row
            self.performSegueWithIdentifier("showStudentInfoViewController", sender: self)
        } else if indexPath.section == classroomDeleteSec {
            self.didPressToDeleteClassroom()
        } else if indexPath.section == classroomInfoSec {
            self.didPressToChangeClassroomName()
        }
    }
    
    //MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRegisterStudentViewController" {
            let dest = segue.destinationViewController as? RegisterStudentViewController
            if let register = dest {
                register.roomID = self.roomID
            }
        }
        if segue.identifier == "showStudentInfoViewController" {
            let dest = segue.destinationViewController as? ManageStudentInfoViewController
            if let info = dest {
                info.student = self.students[selectedStudentIndex]
            }
        }
    }

    
    @IBAction func goBackToManageStudentsViewController(segue: UIStoryboardSegue) {
        if self.mustRealoadData {
            self.tableView.reloadData()
            self.mustRealoadData = false
        }
    }
    
}
