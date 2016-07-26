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
        updateData()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Nova Fase", style: .Plain, target: self, action: #selector (didPressToAddNewPhase))
        self.title = "Fases"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didPressToAddNewPhase() {
        let alert = UIAlertController(title: "Adicionar nova fase", message: "Digite o nome da nova fase", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "ex: Berçário, Pré-Escola..."
            self.newPhaseTextField = textField
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let submitAction = UIAlertAction(title: "Criar", style: .Default) { (alert) in
            let credential = NinoSession.sharedInstance.credential
            guard let token = credential?.token else {
                //TODO: back to login
                return
            }
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
                } catch {
                    //TODO: handle newPhase errors
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
        guard let token = NinoSession.sharedInstance.credential?.token else {
            //TODO: go to login
            return
        }
        guard let school = NinoSession.sharedInstance.schoolID else {
            //TODO: go to login
            return
        }
        PhaseBO.getPhases(token, schoolID: school, completionHandler: { (phases) in
            do {
                let newPhases = try phases()
                self.phases.removeAll()
                for phase in newPhases {
                    self.phases.append(phase)
                }
                self.tableView.reloadData()
            } catch {
                //TODO: handle getPhases error
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
        backButton.title = "Fases"
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
