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
//        NinoNotificationManager.sharedInstance.addObserverForSchoolUpdates(self, selector: #selector(schoolUpdated))
//        NinoNotificationManager.sharedInstance.addObserverForPhasesUpdates(self, selector: #selector(phasesUpdated))
        NinoNotificationManager.sharedInstance.addObserverForStudentsUpdates(self, selector: #selector(studentsUpdated))
//        NinoNotificationManager.sharedInstance.addObserverForRoomsUpdatesFromServer(self, selector: #selector(roomsUpdatedFromServer))
        //xrschoolNameLabel.text = "DID WORK"
        //self.tableView.registerNib(UINib(nibName: "StudentProfileListHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "StudentProfileListHeader")
        let nib = UINib(nibName: "StudentProfileListHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "StudentProfileListHeader")
        self.tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        //self.studentProfileTableView.reloadData()
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
        if let error = userInfo["error"] {
            //TODO: handle error
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
        if let token = NinoSession.sharedInstance.credential?.token {
            SchoolBO.getSchool(token, completionHandler: { (school) in
                do {
                    let school = try school()
                    header.schoolNameLabel.text = school.name
                } catch let error {
                    //TODO: Handle error
                    NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                }
            })
        }
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
//        thisCell.profileImageView.image = UIImage(named: "baby1")
//        thisCell.guardianFirstNames = ["Carlos", "Danilo"]
//        thisCell.studentName = "Amanda"
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
    
    //MARK: Notification Manager methods
//    @objc private func schoolUpdated() {
//        print("School notification working")
//    }
    
//    @objc private func phasesUpdated(notification: NSNotification) {
//        guard let userInfo = notification.userInfo else {
//            //TODO: Unexpected case
//            return
//        }
//        if let error = userInfo["error"] {
//            //TODO: handle error
//        } else if let message = userInfo["info"] as? NotificationMessage {
//            if let newPhases = message.dataToInsert as? [Phase] {
//                self.phases.appendContentsOf(newPhases)
//            }
//            //TODO: updated phases
//            //TODO: deleted phases
//        }
//        self.getRooms()
//    }
    
//    private func getRooms() {
//        if self.phases.count > 0 {
//            self.rooms.removeAll()
//            RoomBO.getAllRooms({ (rooms) in
//                do {
//                    let newRooms = try rooms()
//                    for room in newRooms {
//                        self.rooms.append(room)
//                    }
//                    self.roomsUpdated()
//                } catch let error {
//                    //TODO: handle error
//                    NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
//                }
//            })
//        }
//    }
    
//    private func roomsUpdated() {
//        //TODO: reload rooms buttons
//    }
    
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
            StudentBO.getStudent(room) { (students) in
                do {
                    let students = try students()
                    for student in students {
                        self.students.append(student.id)
                        self.dates.append(student.createdAt)
//                        DraftBO.getDraftsForStudent(student.id, completionHandler: { (getDraft) in
//                            do {
//                                try getDraft()
//                            } catch let error {
//                                //TODO: handle get drafts error
//                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
//                            }
//                        })
                        //TODO: get guardian for student
                    }
                    self.studentProfileTableView.reloadData()
                } catch let error {
                    //TODO: HANDLE
                    NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                }
                
            }
        }
    }
    
//    @objc private func roomsUpdatedFromServer(notification: NSNotification) {
//        guard let userInfo = notification.userInfo else {
//            //TODO: Unexpected case
//            return
//        }
//        if let error = userInfo["error"] {
//            //TODO: handle error
//        } else if let message = userInfo["info"] as? NotificationMessage {
//            if let newRooms = message.dataToInsert as? [Room] {
//                for room in newRooms {
//                    self.rooms.append(room)
//                }
//            }
//            //TODO: updated phases
//            //TODO: deleted phases
//        }
//        self.roomsUpdated()
//    }
    //MARK: Student Profile List Header Delegate
    func didTapPhaseButton(sender: UIButton) {
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
