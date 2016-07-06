//
//  SchoolManagementTableViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/4/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

struct DataStructure {
    var section: String
    var rows: NSMutableArray
    var icons: [UIImage]
}

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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("configCell")
        cell!.textLabel!.text = self.sections[indexPath.section].rows[indexPath.row] as? String
        cell!.imageView!.image = self.sections[indexPath.section].icons[indexPath.row]
        if indexPath.section != 2 {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
            print(view.bounds.height)
        }
    }
    
    
    
   func configureSections() {
        self.sections.append(DataStructure(section: "Administração",rows: ["Cadastrar Aluno","Gerenciar Educadores","Gerenciar Turmas" /*"Recuperar Senha"*/],icons: [UIImage(named: "Becke_Adicionar-bebe")!,UIImage(named: "Becke_Darth-Vader")!, UIImage(named: "iconPlaceholder")!]))
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

        self.performSegueWithIdentifier("showManageEducatorsViewController", sender: indexPath)
        
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
