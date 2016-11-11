//
//  SelectClassroomTableViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 8/10/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

private class SelectorRoom {
    var name: String
    var id: String
    
    init(name: String, id: String) {
        self.id = id
        self.name = name
    }
}

private class SelectorPhase {
    var name: String
    var rooms: [SelectorRoom]
    var id: String
    init(name: String, id: String) {
        self.id = id
        self.name = name
        self.rooms = [SelectorRoom]()
    }
}

protocol ChooseClassroomDelegate {
    func didChangeSelectedPhase(newTitle: String, phase: String, room: String)
}

class SelectClassroomTableViewController: UITableViewController {
    
    private var phases = [SelectorPhase]()
    var delegate: ChooseClassroomDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NinoNotificationManager.sharedInstance.addObserverForPhasesUpdates(self, selector: #selector(phasesUpdated))
        NinoNotificationManager.sharedInstance.addObserverForRoomsUpdatesFromServer(self, selector: #selector(roomsUpdated))
        
        reloadData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)// Removes empty cells
        self.tableView.separatorColor = UIColor.clearColor()
        self.preferredContentSize = CGSize(width: tableView.frame.width, height: tableView.frame.height + 15 )

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.resizeView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return phases.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phases[section].rooms.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectClassroomTableViewCell", forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismiss {
            let phase = self.phases[indexPath.section]
            let room = self.phases[indexPath.section].rooms[indexPath.item]
            self.delegate?.didChangeSelectedPhase(phase.name.uppercaseString + " | " + room.name, phase: phase.id, room: room.id)
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

            guard let phaseCell = cell as? SelectClassroomTableViewCell else {
                return
            }
            phaseCell.configureCell(phases[indexPath.section].rooms[indexPath.row].name, profileImage: nil, index: indexPath.row)
            phaseCell.accessoryType = .None
            
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.phases[section].name
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.whiteColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
        }
    }
    

    func reloadData() {
        for phase in self.phases {
            phase.rooms.removeAll()
        }
        self.phases.removeAll()
        if let token = NinoSession.sharedInstance.credential?.token {
            if let schoolID = NinoSession.sharedInstance.schoolID {
                PhaseBO.getPhases(token, schoolID: schoolID, completionHandler: { (phases) in
                    do {
                        let phases = try phases()
                        for phase in phases {
                            RoomBO.getRooms(phase.id, completionHandler: { (rooms) in
                                do {
                                    let rooms = try rooms()
                                    let thisPhase = SelectorPhase(name: phase.name, id: phase.id)
                                    for room in rooms {
                                        thisPhase.rooms.append(SelectorRoom(name: room.name, id: room.id))
                                    }
                                    self.phases.append(thisPhase)
                                    self.tableView.reloadData()
                                    self.resizeView()
                                } catch let error {
                                    //TODO: HANDLE ERROR AGAIN
                                    NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                }
                            })
                        }
                    } catch let error {
                        //TODO: HANDLE ERROR AGAIN
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                })
            }
        }
    }
    
    func resizeView() {
        guard let firstCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) else {
            self.preferredContentSize = CGSize(width: 300, height: 100)
            return
        }
        let allSecsHeight = (20) * CGFloat(self.tableView.numberOfSections)
        var numberOfRows = 0
        var secNum = 0
        while secNum < tableView.numberOfSections {
            numberOfRows += tableView.numberOfRowsInSection(secNum)
            secNum += 1
        }
        let allRowsHeight = CGFloat(numberOfRows) * firstCell.frame.height
        self.preferredContentSize = CGSize(width: 300, height: allSecsHeight + allRowsHeight)
        //self.preferredContentSize = CGSize(width: 200, height: 200)
        
    }
    
    // MARK: Notifications
    
    func roomsUpdated (notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        if let error = userInfo["error"] {
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newRooms = message.dataToInsert as? [Room] {
                if newRooms.count > 0 {
                    let phaseID = newRooms.first!.phaseID
                    for phase in self.phases {
                        if phase.id == phaseID {
                            for room in newRooms {
                                phase.rooms.append(SelectorRoom(name: room.name, id: room.id))
                            }
                        }
                    }
                    self.tableView.reloadData()
                    self.resizeView()
                }
            }
        }
        
        //TODO: DELETED
        //TODO: UPDATED
    }
    
    func phasesUpdated (notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            //TODO:
            return
        }
        
        if let error = userInfo["error"] {
            //TODO:
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newPhases = message.dataToInsert as? [Phase] {
                if newPhases.count > 0 {
                    for phase in newPhases {
                        RoomBO.getRooms(phase.id, completionHandler: { (rooms) in
                            do {
                                let rooms = try rooms()
                                let thisPhase = SelectorPhase(name: phase.name, id: phase.id)
                                for room in rooms {
                                    thisPhase.rooms.append(SelectorRoom(name: room.name, id: room.id))
                                }
                                self.phases.append(thisPhase)
                                self.tableView.reloadData()
                                self.resizeView()
                            } catch let error {
                                //TODO: HANDLE ERROR AGAIN
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                            }
                        })
                    }
                }
            }
        }
        
        //TODO: DELETED
        //TODO: UPDATED
    }

}
