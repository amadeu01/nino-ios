//
//  StudentProfileListController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 6/28/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentProfileListController: UIViewController, UITableViewDelegate, UITableViewDataSource { //TODO: TableViewDelegate and TableViewDataSource

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
    }
    //MARK: TableView Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return StudentProfileTableViewCell()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Configure cell
        guard let thisCell = cell as? StudentProfileTableViewCell else {
            //Not a StudentProfileTableViewCell
            return
        }
        thisCell.profileImageView.image = UIImage(named: "baby1")
        thisCell.guardianFirstNames = ["Carlos", "Danilo"]
        thisCell.studentName = "Amanda"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Only one section
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
}
