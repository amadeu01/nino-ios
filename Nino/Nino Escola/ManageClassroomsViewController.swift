//
//  ManageClassroomsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/8/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
struct ClassMock{
    var name: String?
    var id: Int!
}
class ManageClassroomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //Define section
    let classroomSec = 0
    let addNewSec = 1
    var phaseName = "Berçário"
    var goBackButtonName = "Fases"
    var classes = [ClassMock]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNinoDefaultBackGround()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        classes.append(ClassMock(name: "Manhã", id: 1))
        classes.append(ClassMock(name: "Tarde", id: 2))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Nova Turma", style: .Plain, target: self, action: #selector (didPressToAddNewClassroom))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didPressToAddNewClassroom() {
        let alert = UIAlertController(title: "Adicionar nova turma", message: "Digite o nome da nova turma", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "ex: Turma A, Tarde..."
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let submitAction = UIAlertAction(title: "Criar", style: .Default) { (alert) in
            //TODO: Create New phase
        }
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // MARK: TableView Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == addNewSec {
            return 1
        } else if section == classroomSec{
            return 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == addNewSec {
            guard let newClassroomCell = tableView.dequeueReusableCellWithIdentifier("addNewClassroom") else {
                print("Error inside ManageClassroomsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            newClassroomCell.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
            return newClassroomCell
        } else if indexPath.section == classroomSec {
            guard let classroomCell = tableView.dequeueReusableCellWithIdentifier("classroomProfileTableViewCell") else {
                print("Error inside ManageClassroomsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            classroomCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return classroomCell
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            // TODO: Configure add new classroom cell
            if indexPath.section == classroomSec {
                // Configure add new phase cell
                guard let classroomCell = cell as? ClassroomTableViewCell else {
                    return
                }
                classroomCell.name = classes[indexPath.row].name
            }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == addNewSec {
            return 70
        } else {
            return 90
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == addNewSec {
            return 70
        } else {
            return 90
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == addNewSec {
            performSegueWithIdentifier("showRegisterNewClassroomViewController", sender: self)
            
        } else if indexPath.section == classroomSec {
            self.performSegueWithIdentifier("showClassroomProfileViewController", sender: self)
        }
    }
    
    
    // MARK: Navigation
    
    @IBAction func goBackToManageClassroomsViewController(segue: UIStoryboardSegue) {
        
    }
}
