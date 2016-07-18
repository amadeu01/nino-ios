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

struct ExtraPhaseOption{
    var name: String?
    var value: String?
}
class ManageClassroomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //Define section
    let classroomSec = 0
    let classroomInfoSec = 1
    let classroomDeleteSec = 2
    var phaseName = "Berçário"
    var goBackButtonName = "Fases"
    var classes = [ClassMock]()
    var extraRows = [ExtraPhaseOption]()
    
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
    func didPressToDeletePhase() {
        let alert = UIAlertController(title: "Deletar Fase", message: "Deseja deletar a fase \(self.title!)?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let deleteAction = UIAlertAction(title: "Deletar", style: .Destructive) { (alert) in
            //TODO: Create New phase
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func didPressToChangePhaseName() {
        let alert = UIAlertController(title: "Alterar o nome da fase", message: "Digite um novo nome para a fase \(self.title!)", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.text = self.title
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel) { (alert) in
            //Did press cancel.
        }
        let changeAction = UIAlertAction(title: "Alterar", style: .Default) { (alert) in
            //TODO: Create New phase
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
        if section == classroomSec{
            return 2
        }else if section == classroomInfoSec {
            return 1
        } else if section == classroomDeleteSec {
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
        } else if indexPath.section == classroomInfoSec {
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
                classroomCell.configureCell(classes[indexPath.row].name, profileImage: nil, index: indexPath.row)
        } else if indexPath.section == classroomInfoSec {
            // configure info cell
            if indexPath.row == 0 {
                cell.detailTextLabel?.text = self.title
                cell.textLabel?.text = "Nome"
            }
            } else if indexPath.section == classroomDeleteSec {
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Deletar Fase \(self.title!)"
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
            self.performSegueWithIdentifier("showClassroomProfileViewController", sender: self)
        } else if indexPath.section == classroomDeleteSec {
            self.didPressToDeletePhase()
        } else if indexPath.section == classroomInfoSec {
            self.didPressToChangePhaseName()
        }
    }
    
    
    // MARK: Navigation
    
    @IBAction func goBackToManageClassroomsViewController(segue: UIStoryboardSegue) {
        
    }
}
