//
//  StudentProfileListController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 6/28/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileListController: UITableViewController, StudentProfileListHeaderDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var studentProfileTableView: UITableView!
    @IBOutlet weak var footer: UIView!
    
    var phases = [Phase]()
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentProfileTableView.dataSource = self
        self.studentProfileTableView.delegate = self
        //registering for notification
        NinoNotificationManager.sharedInstance.addObserverForSchoolUpdates(self, selector: #selector(schoolUpdated))
        NinoNotificationManager.sharedInstance.addObserverForPhasesUpdates(self, selector: #selector(phasesUpdated))
        NinoNotificationManager.sharedInstance.addObserverForRoomsUpdatesFromServer(self, selector: #selector(roomsUpdatedFromServer))
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
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table View Delegate

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 120
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("StudentProfileListHeader")
//swiftlint:disable force_cast
        let header = cell as! StudentProfileListHeader
        header.delegate = self
        header.schoolNameLabel.text = "Escola Nino"
        return cell
    }
    //MARK: TableView Data Source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.studentProfileTableView.dequeueReusableCellWithIdentifier("profileTableViewCell") as? StudentProfileTableViewCell
        guard let thisCell = cell else {
            return StudentProfileTableViewCell()
        }
        
        return thisCell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Configure cell
        guard let thisCell = cell as? StudentProfileTableViewCell else {
            //Not a StudentProfileTableViewCell
            return
        }
        thisCell.profileImageView.image = UIImage(named: "baby1")
        thisCell.guardianFirstNames = ["Carlos", "Danilo"]
        thisCell.studentName = "Amanda"
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Only one section
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showStudentProfile", sender: self)
    }
    
    //MARK: Notification Manager methods
    @objc private func schoolUpdated() {
        //TODO: update school label
        print("School notification working!")
    }
    
    @objc private func phasesUpdated(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            //TODO: Unexpected case
            return
        }
        if let error = userInfo["error"] {
            //TODO: handle error
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newPhases = message.dataToInsert as? [Phase] {
                for phase in newPhases {
                    self.phases.append(phase)
                }
            }
            //TODO: updated phases
            //TODO: deleted phases
        }
        self.getRooms()
    }
    
    private func getRooms() {
        if self.phases.count > 0 {
            RoomBO.getAllRooms({ (rooms) in
                do {
                    let newRooms = try rooms()
                    for room in newRooms {
                        self.rooms.append(room)
                    }
                    self.roomsUpdated()
                } catch {
                    //TODO: handle error
                }
            })
        }
    }
    
    private func roomsUpdated() {
        //TODO: reload rooms buttons
    }
    @objc private func roomsUpdatedFromServer(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            //TODO: Unexpected case
            return
        }
        if let error = userInfo["error"] {
            //TODO: handle error
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newRooms = message.dataToInsert as? [Room] {
                for room in newRooms {
                    self.rooms.append(room)
                }
            }
            //TODO: updated phases
            //TODO: deleted phases
        }
        self.roomsUpdated()
    }
    //MARK: Student Profile List Header Delegate
    func didTapPhaseButton(sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "SelectClassroom",
            bundle: nil)
        
        var menuViewController: SelectClassroomTableViewController = storyboard.instantiateViewControllerWithIdentifier("SelectClassroomTableViewController") as! SelectClassroomTableViewController
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = CGSizeMake(300, 400)
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Left
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        popoverMenuViewController?.sourceRect = CGRect(x: sender.frame.width,y: sender.frame.height/2,width: 1,height: 1)
        presentViewController(menuViewController,animated: true,completion: nil)
        
    }
}
