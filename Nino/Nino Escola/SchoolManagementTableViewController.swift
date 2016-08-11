//
//  SchoolManagementTableViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/4/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit



class SchoolManagementTableViewController: UITableViewController {

    var sections = [DataStructure]()
    var selectedRow = 0
    
    @IBOutlet var schoolManagementTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSections()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sections[section].rows.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].section
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("configCell")
        cell!.textLabel!.text = self.sections[indexPath.section].rows[indexPath.row]
        cell!.imageView!.image = self.sections[indexPath.section].icons[indexPath.row]
        if indexPath.section != 2 {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell!
    }
   func configureSections() {
        self.sections.append(DataStructure(section: "Dia-a-dia", rows: ["Calendário", "Cardápio"], icons: [UIImage(named: "iconPlaceholder")!, UIImage(named: "iconPlaceholder")!]))
        self.sections.append(DataStructure(section: "Administração", rows: ["Gerenciar Educadores", "Gerenciar Turmas" /*"Recuperar Senha"*/], icons: [UIImage(named: "Becke_Darth-Vader")!, UIImage(named: "iconPlaceholder")!]))
        self.sections.append(DataStructure(section: "Sobre", rows: ["Legal"], icons: [UIImage(named: "Becke_Creditos-pais")!]))
        self.sections.append(DataStructure(section: "Conta", rows: ["Sair"], icons: [UIImage(named: "Becke_Sair")!]))
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = 0
        if indexPath.section > 0 {
            for index in 0...(indexPath.section - 1) {
                self.selectedRow += self.sections[index].rows.count
            }
        }
        self.selectedRow += indexPath.row
        
        switch selectedRow {
        case 0: //Schedule
            self.performSegueWithIdentifier("showScheduleViewController", sender: indexPath)
        case 1: //Meals Menus
            self.performSegueWithIdentifier("showMealMenuViewController", sender: indexPath)
        case 2: //Manage Educator
            self.performSegueWithIdentifier("showManageEducatorsViewController", sender: indexPath)
        case 3: //Manage Phases
            self.performSegueWithIdentifier("showManageClassroomsViewController", sender: indexPath)
        case 4: //Legal Stuff
            self.performSegueWithIdentifier("showLegalStuffViewController", sender: indexPath)
        case 5: //Logout
            logOut()
        default: //Just do nothing
            print("Error: A cell was selected but the app does not know what to do with it. What's going on, Nino?")
        }
    }
    
    //MARK: Handling function:
    
    func logOut() {
        //TODO: Should prompt the user if he would like to logg
    }
}
