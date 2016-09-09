//
//  ManageClassroomsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/8/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManageClassroomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var selectedClassroomIndex = 0
    //Define section
    let classroomSec = 0
    let phaseInfoSec = 1
    let phaseDeleteSec = 2
    //Names
    var goBackButtonName = NSLocalizedString("PHASES", comment: "Phases")
    var rooms = [Room]()
    var phaseID: String?
    
    var newRoomTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        NinoNotificationManager.sharedInstance.addObserverForRoomsUpdatesFromServer(self, selector: #selector(roomsUpdatedFromServer))
        self.updateRooms()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("ROOMS_NEW", comment: "New Room"), style: .Plain, target: self, action: #selector (didPressToAddNewClassroom))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateRooms() {
        
        guard let id = phaseID else {
            //TODO: return to phases manager
            return
        }
        
        RoomBO.getRooms(id) { (rooms) in
            do {
                let rooms = try rooms()
                self.rooms.removeAll()
                for room in rooms {
                    self.rooms.append(room)
                }
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            } catch let error {
                //TODO: handle getRoom errors
                NinoSession.sharedInstance.kamikaze(["error":error, "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
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
                self.tableView.reloadData()
            }
            //TODO: updated rooms
            //TODO: deleted rooms
        }
    }
    
    func didPressToAddNewClassroom() {
        let alert = UIAlertController(title: NSLocalizedString("ROOMS_ADD", comment: "Add new room"), message: NSLocalizedString("ROOMS_INS_NAME", comment: ""), preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
            textField.autocorrectionType = UITextAutocorrectionType.Default
            textField.placeholder = NSLocalizedString("ROOM_ADD_PH", comment: "")
            self.newRoomTextField = textField
            
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let submitAction = UIAlertAction(title: NSLocalizedString("GENERAL_CREATE", comment: ""), style: .Default) { (alert) in
            guard let name = self.newRoomTextField?.text else {
                //TODO: empty field default alert
                return
            }
            guard let token = NinoSession.sharedInstance.credential?.token else {
                //TODO: back to login
                return
            }
            guard let currentPhase = self.phaseID else {
                //TODO: back to phases manager
                return
            }
            RoomBO.createRoom(currentPhase, name: name, completionHandler: { (room) in
                do {
                    let room = try room()
                    self.rooms.append(room)
                    self.tableView.reloadData()
                } catch let error {
                    //TODO: handle createRoom error
                    print("createRoom error: " + ((error as? ServerError)?.description())!)
                    NinoSession.sharedInstance.kamikaze(["error":error, "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func didPressToDeletePhase() {
        let alert = UIAlertController(title: NSLocalizedString("PHASE_DELETE", comment: "Delete Phase"), message: "Deseja deletar a fase \(self.title!)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let deleteAction = UIAlertAction(title: NSLocalizedString("GENERAL_DELETE", comment: "Delete"), style: .Destructive) { (alert) in
            //TODO: Delete phase
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func didPressToChangePhaseName() {
        let alert = UIAlertController(title: NSLocalizedString("PHASE_CHANGE_NAME_ALERT_TITLE", comment: ""), message: "\(NSLocalizedString("PHASE_CHANGE_NAME_ALERT_DESC", comment: ""))\(self.title!)", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.text = self.title
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let changeAction = UIAlertAction(title: NSLocalizedString("GENERAL_CHANGE", comment: ""), style: .Default) { (alert) in
            //TODO: change phase name
        }
        alert.addAction(cancelAction)
        alert.addAction(changeAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == classroomSec {
            return self.rooms.count
        } else if section == phaseInfoSec {
            return 1
        } else if section == phaseDeleteSec {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == classroomSec {
            guard let classroomCell = tableView.dequeueReusableCellWithIdentifier("classroomProfileTableViewCell") else {
                print("Error inside ManageClassroomsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            return classroomCell
        } else if indexPath.section == phaseInfoSec {
            guard let infoCell = tableView.dequeueReusableCellWithIdentifier("nameOfTheClassroomCell") else {
            return UITableViewCell(style: .Value1, reuseIdentifier: "nameOfTheClassroomCell")
            }
            return infoCell
        }
        return UITableViewCell()
    }
    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
        let headerView  = UIView(frame: frame)
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
            print(view.bounds.height)
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            // TODO: Configure add new classroom cell
            if indexPath.section == classroomSec {
                // Configure add new phase cell
                guard let classroomCell = cell as? ClassroomTableViewCell else {
                    return
                }
                classroomCell.configureCell(rooms[indexPath.row].name, profileImage: nil, index: indexPath.row)
        } else if indexPath.section == phaseInfoSec {
            // configure info cell
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = self.title
                cell.textLabel?.text = NSLocalizedString("PROF_NAME", comment: "Name")
            }
            } else if indexPath.section == phaseDeleteSec {
                if indexPath.row == 0 {
                    cell.textLabel?.text = NSLocalizedString("PHASE_DELETE", comment: "Delete Phase") + " \(self.title!)"
                    cell.textLabel?.textColor = UIColor.redColor()
                }
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == classroomSec {
            return 90
        }
        return 70
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == classroomSec {
        return 90
        }
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == classroomSec {
            selectedClassroomIndex = indexPath.row
            self.performSegueWithIdentifier("showClassroomProfileViewController", sender: self)
        } else if indexPath.section == phaseDeleteSec {
            self.didPressToDeletePhase()
        } else if indexPath.section == phaseInfoSec {
            self.didPressToChangePhaseName()
        }
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showClassroomProfileViewController" {
            let backButton = UIBarButtonItem()
            backButton.title = NSLocalizedString("ROOMS", comment: "Rooms")
            navigationItem.backBarButtonItem = backButton
            
            guard let toVC = segue.destinationViewController as? ManageStudentsViewController else {
                return
            }
            // Title that will bedisplayed in the navigation bar
            toVC.title = rooms[selectedClassroomIndex].name
            toVC.roomID = rooms[selectedClassroomIndex].id
        }
    }
    
    @IBAction func goBackToManageClassroomsViewController(segue: UIStoryboardSegue) {
    }
}
