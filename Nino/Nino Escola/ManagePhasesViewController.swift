//
//  ManagePhasesViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/13/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManagePhasesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var phases = [Phase]()
    var selectedPhaseIndex = 0
    //Define sections numbers
    let phaseSec = 0
    let addNewPhase = 1
    var newPhaseTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        NinoNotificationManager.sharedInstance.addObserverForPhasesUpdates(self, selector: #selector(manageUpdatedPhases))
        updateData()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("PHASES_NEW", comment: "New Phase"), style: .Plain, target: self, action: #selector (didPressToAddNewPhase))
        self.title = NSLocalizedString("PHASES", comment: "Phases")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func manageUpdatedPhases(notification: NSNotification) {
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
                self.tableView.reloadData()
            }
            //TODO: updated phases
            //TODO: deleted phases
        }
    }
    
    func didPressToAddNewPhase() {
        let alert = UIAlertController(title: NSLocalizedString("PHASE_ADD", comment: "Add new phase"), message: NSLocalizedString("PHASE_INS_NAME", comment: ""), preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
            textField.autocorrectionType = UITextAutocorrectionType.Default
            textField.placeholder = NSLocalizedString("PHASE_ADD_PH", comment: "")
            self.newPhaseTextField = textField
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: "Cancel"), style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let submitAction = UIAlertAction(title: NSLocalizedString("GENERAL_CREATE", comment: ""), style: .Default) { (alert) in
            NinoSession.sharedInstance.getCredential({ (getCredential) in
                do {
                    let token = try getCredential().token
                    let school = NinoSession.sharedInstance.schoolID
                    guard let schoolID = school else {
                        //TODO: back to login
                        return
                    }
                    guard let name = self.newPhaseTextField?.text else {
                        //TODO: show default alert for empty field
                        return
                    }
                    PhaseBO.createPhase(token, schoolID: schoolID, name: name, completionHandler: { (phase) in
                        do {
                            let newPhase = try phase()
                            self.phases.append(newPhase)
                            self.tableView.reloadData()
                        } catch let error {
                            //TODO: handle newPhase errors
                            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                        }
                    })
                } catch let error {
                    //TODO: back to login
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    //MARK: Data
    func updateData() {
    //get phases
        NinoSession.sharedInstance.getCredential({ (getCredential) in
            do {
                let token = try getCredential().token
                guard let school = NinoSession.sharedInstance.schoolID else {
                    //TODO: go to login
                    return
                }
                PhaseBO.getPhases(token, schoolID: school) { (phases) in
                    do {
                        let newPhases = try phases()
                        self.phases.removeAll()
                        for phase in newPhases {
                            self.phases.append(phase)
                        }
                        self.tableView.reloadData()
                    } catch let error {
                        //TODO: handle getPhases error
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                }
            } catch let error {
                //TODO: Handle
            }
        })
    }
    // MARK: TableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == addNewPhase {// Add new Phase
            return 1
        } else if section == phaseSec {
            return phases.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == addNewPhase {
            guard let newPhaseCell = tableView.dequeueReusableCellWithIdentifier("addNewPhase") else {
                print("Error inside ManagePhasesViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            newPhaseCell.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
            return newPhaseCell
        } else {
            guard let phaseCell = tableView.dequeueReusableCellWithIdentifier("phaseProfileTableViewCell") else {
                print("Error inside ManagePhasesViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            phaseCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return phaseCell
        }
    }

    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {//Deletes the blank space below the cell
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
        let headerView  = UIView(frame: frame)
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == phaseSec {
            // Configure add new phase cell
            guard let phaseCell = cell as? PhaseTableViewCell else {
                return
            }
            phaseCell.configureCell(phases[indexPath.row].name, profileImage: nil, index: indexPath.row)
            phaseCell.accessoryType = .DisclosureIndicator
            
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == addNewPhase {
            return 70
        } else {
            return 90
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == addNewPhase {
            return 70
        } else {
            return 90
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == addNewPhase {
            performSegueWithIdentifier("showRegisterNewPhaseViewController", sender: self)
            
        } else {
            self.selectedPhaseIndex = indexPath.row
            self.performSegueWithIdentifier("showPhaseProfileViewController", sender: self)
        }
    }
    // MARK: Navigation
    @IBAction func goBackToPhasesViewController(segue: UIStoryboardSegue) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhaseProfileViewController" {
        let backButton = UIBarButtonItem()
        backButton.title = NSLocalizedString("PHASES", comment: "Phases")
        navigationItem.backBarButtonItem = backButton
        
        guard let toVC = segue.destinationViewController as? ManageClassroomsViewController else {
            return
        }
        // Title that will bedisplayed in the navigation bar    
        toVC.title = phases[selectedPhaseIndex].name
        toVC.phaseID = phases[selectedPhaseIndex].id
        }
    }
    
}
