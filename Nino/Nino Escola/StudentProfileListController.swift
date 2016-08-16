//
//  StudentProfileListController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 6/28/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileListController: UITableViewController {

    
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
        print("School notification working")
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
                self.phases.appendContentsOf(newPhases)
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
}
