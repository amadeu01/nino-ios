//
//  StudentProfileListController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 6/28/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileListController: UITableViewController, StudentProfileListHeaderDelegate, UIPopoverPresentationControllerDelegate, ChooseClassroomDelegate {
    
    @IBOutlet weak var studentProfileTableView: UITableView!
    @IBOutlet weak var footer: UIView!
    
    var phases = [Phase]()
    var rooms = [Room]()
    
    var currentHeader: StudentProfileListHeader?
    
    var currentRoom: String?
    var currentPhase: String?
    var currentStudent: String?
    
    private var students = [String]()
    private var dates = [NSDate?]()
    
    override func viewDidLoad() {
        self.currentRoom = nil
        super.viewDidLoad()
        self.studentProfileTableView.dataSource = self
        self.studentProfileTableView.delegate = self
        //registering for notification
        NinoNotificationManager.sharedInstance.addObserverForStudentsUpdates(self, selector: #selector(studentsUpdated))
        let nib = UINib(nibName: "StudentProfileListHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "StudentProfileListHeader")
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func studentsUpdated(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            //TODO: Unexpected case
            return
        }
        if let error = userInfo["error"] as? NotificationMessage {
            if error.serverError != nil {
                let alert = DefaultAlerts.serverErrorAlert(error.serverError!, title: "Falha na atualização", customAction: nil)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newStudents = message.dataToInsert as? [Student] {
                for student in newStudents {
                    self.students.append(student.id)
                    self.dates.append(student.createdAt)
                    //TODO: get guardian for student
                }
                self.studentProfileTableView.reloadData()
            }
            //TODO: updated students
            //TODO: deleted students
        }
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Delegate

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let headerHeight = self.view.frame.height * 0.15
        return headerHeight
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("StudentProfileListHeader")
//swiftlint:disable force_cast
        let header = cell as! StudentProfileListHeader
        self.currentHeader = header
        header.delegate = self
        NinoSession.sharedInstance.getCredential({ (getCredential) in
            do {
                let token = try getCredential().token
                SchoolBO.getSchool(token, completionHandler: { (school) in
                    do {
                        let school = try school()
                        header.schoolNameLabel.text = school.name
                    } catch let error {
                        //TODO: Handle error
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                })
            } catch let error {
                
            }
        })
        header.schoolNameLabel.text = ""
        return cell
    }
    //MARK: TableView Data Source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.studentProfileTableView.dequeueReusableCellWithIdentifier("profileTableViewCell") as? StudentProfileTableViewCell
        guard let thisCell = cell else {
            return StudentProfileTableViewCell()
        }
        
        thisCell.studentID = students[indexPath.item]
        
        return thisCell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Configure cell
        guard let thisCell = cell as? StudentProfileTableViewCell else {
            //Not a StudentProfileTableViewCell
            return
        }

    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Only one section
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SchoolSession.currentStudent = students[indexPath.item]
        SchoolSession.studentCreatedAt = self.dates[indexPath.item]
        self.performSegueWithIdentifier("showStudentProfile", sender: self)
    }
    

    
    func didChangeSelectedPhase(newTitle: String, phase: String, room: String) {
        self.currentRoom = room
        self.currentPhase = phase
        self.currentHeader?.classroomButton.setTitle(newTitle, forState: .Normal)
        SchoolSession.currentRoom = room
        SchoolSession.currentPhase = phase
        self.reloadData()
    }
    
    @objc private func reloadData() {
        self.students.removeAll()
        if let room = self.currentRoom {
            do {
                try StudentBO.getStudent(room, completionHandler: { (students) in
                    let students = students()
                    for student in students {
                        self.students.append(student.id)
                        self.dates.append(student.createdAt)
                    }
                    self.studentProfileTableView.reloadData()
                })
            } catch {
                let alertVC = DefaultAlerts.userDidNotLoggedIn()
                self.presentViewController(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NinoNotificationManager.sharedInstance.removeObserverForStudentsUpdates(self)
    }

    //MARK: Student Profile List Header Delegate
    func didTapPhaseButton(sender: UIButton) {
        self.reloadData()
        let storyboard : UIStoryboard = UIStoryboard(
            name: "SelectClassroom",
            bundle: nil)
        
        let menuViewController: SelectClassroomTableViewController = storyboard.instantiateViewControllerWithIdentifier("SelectClassroomTableViewController") as! SelectClassroomTableViewController
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = CGSizeMake(300, 400)
        menuViewController.delegate = self
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Left
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        popoverMenuViewController?.sourceRect = CGRect(x: sender.frame.width, y: sender.frame.height/2,width: 1, height: 1)
        presentViewController(menuViewController, animated: true, completion: nil)
        
    }
}
