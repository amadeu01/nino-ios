//
//  SchoolManagementTableViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/4/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit


struct DataSection {
    var name: String
    var rows: [DataRow]
}
struct DataRow {
    var name: String
    var image: UIImage
    var identifier: String
}




class SchoolManagementTableViewController: UITableViewController {

    //var sections = [DataStructure]()

    var selectedRow = 0
    var theseSecs = [DataSection]()
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
        //return self.sections.count
        return self.theseSecs.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.sections[section].rows.count
        let a = theseSecs[section].rows
        
        return a.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return self.sections[section].section
        return self.theseSecs[section].name
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("configCell")
        let data = theseSecs[indexPath.section].rows[indexPath.row]
        cell?.textLabel?.text = data.name
        cell?.imageView?.image = data.image
        if indexPath.section != 2 {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell!
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
   func configureSections() {
    let adminSecRows = [DataRow(name: "Gerenciar Turmas", image: UIImage(named: "iconPlaceholder")!, identifier: "showManageClassroomsViewController")]
    theseSecs.append(DataSection(name: "Administração", rows: adminSecRows))
    let accountSecRows = [DataRow(name: "Sair", image: UIImage(named: "Becke_Sair")!, identifier: "shouldLogOut")]
    theseSecs.append(DataSection(name: "Conta", rows: accountSecRows))
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = self.theseSecs[indexPath.section].rows[indexPath.row].identifier
        if identifier == "shouldLogOut" {
            logOut()
        } else {
            performSegueWithIdentifier(identifier, sender: self)
        }
    }
    //MARK: Handling function:
    func logOut() {
        //TODO: Should prompt the user if he would like to logg
    }
}
