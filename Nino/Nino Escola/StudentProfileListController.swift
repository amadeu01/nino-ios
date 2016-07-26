//
//  StudentProfileListController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 6/28/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileListController: UITableViewController {

    
    @IBOutlet weak var studentProfileTableView: UITableView!
    @IBOutlet weak var footer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentProfileTableView.dataSource = self
        self.studentProfileTableView.delegate = self
        
        //registering for notification
        NinoNotificationManager.sharedInstance.addObserverForSchoolUpdates(self, selector: #selector(schoolUpdated))
        NinoNotificationManager.sharedInstance.addObserverForPhasesUpdates(self, selector: #selector(phasesUpdated))
        
        //self.studentProfileTableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
    }
    //MARK: TableView Data Source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.studentProfileTableView.dequeueReusableCellWithIdentifier("profileTableViewCell") as? StudentProfileTableViewCell
        guard let thisCell = cell else {
            return StudentProfileTableViewCell()
        }
        
        return thisCell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Configure cell
        guard let thisCell = cell as? StudentProfileTableViewCell else {
            //Not a StudentProfileTableViewCell
            return
        }
        thisCell.profileImageView.image = UIImage(named: "baby1")
        thisCell.guardianFirstNames = ["Carlos", "Danilo"]
        thisCell.studentName = "Amanda"
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Only one section
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showStudentProfile", sender: self)
    }
    
    //MARK: Notification Manager methods
    @objc private func schoolUpdated() {
        //TODO: update school label
        print("School notification working!")
    }
    
    @objc private func phasesUpdated() {
        //TODO: update phases buttons
        print("Phases notification working!")
    }
}
