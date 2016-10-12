//
//  SettingsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 8/26/16.
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

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var theseSecs = [DataSection]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accountSecRows = [DataRow(name: NSLocalizedString("GENERAL_LOGOUT", comment: "Logout"), image: UIImage(named: "Becke_Sair")!, identifier: "shouldLogOut")]
        theseSecs.append(DataSection(name: NSLocalizedString("GENERAL_ACCOUNT", comment: "Account"), rows: accountSecRows))
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: CGRect.zero)// Removes empty cells
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut() {
        let alert = UIAlertController(title: NSLocalizedString("GENERAL_LOGOUT", comment: ""), message: NSLocalizedString("LOGOUT_CONFIRMATION", comment: ""), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("GENERAL_CANCEL", comment: ""), style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("GENERAL_LOGOUT", comment: ""), style: .Destructive, handler: { (act) in
            LoginBO.logout({ (out) in
                do {
                    try out()
                    KeyBO.removePasswordAndUsername()
                    if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                        delegate.loggedIn = false
                        delegate.setupRootViewController(true)
                    }
                } catch let error {
                    //TODO: handle logout error
                    NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                }
            })
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Table View Delegate
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.theseSecs[section].name
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = self.theseSecs[indexPath.section].rows[indexPath.row].identifier
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if identifier == "shouldLogOut" {
            logOut()
        } else {
            performSegueWithIdentifier(identifier, sender: self)
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("configCell")
            let data = theseSecs[indexPath.section].rows[indexPath.row]
            cell?.textLabel?.text = data.name
            cell?.imageView?.image = data.image
            if indexPath.section != 2 {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            return cell!
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    //MARK: Table View Datasour
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theseSecs[section].rows.count
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
