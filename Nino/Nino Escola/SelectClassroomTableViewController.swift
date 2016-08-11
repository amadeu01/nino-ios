//
//  SelectClassroomTableViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 8/10/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
struct ClassroomMock {
    let name: String
}
struct PhaseMock {
    let name: String
    let classrooms: [ClassroomMock]
}
class SelectClassroomTableViewController: UITableViewController {
    
    var phases = [PhaseMock]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)// Removes empty cells
        self.preferredContentSize = CGSize(width: tableView.frame.width, height: tableView.frame.height + 15 )

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let firstCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) else {
            return
        }
        let allSecsHeight = tableView.sectionHeaderHeight * CGFloat(self.tableView.numberOfSections)
        print("All Sections Height is\(allSecsHeight)")
        var numberOfRows = 0
        var secNum = 0
        while (secNum < tableView.numberOfSections) {
            numberOfRows += tableView.numberOfRowsInSection(secNum)
            secNum += 1
        }
        let allRowsHeight = CGFloat(numberOfRows) * firstCell.frame.height
        print("All Row Height is\(allSecsHeight)")
        self.preferredContentSize = CGSize(width: 300, height: allRowsHeight + allSecsHeight)
        print("All Row Height is\(allSecsHeight)")
        //self.preferredContentSize = CGSize(width: 200, height: 200)
        print("Is this real life")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return phases.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return phases[section].classrooms.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectClassroomTableViewCell", forIndexPath: indexPath)


        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

            guard let phaseCell = cell as? SelectClassroomTableViewCell else {
                return
            }
            phaseCell.configureCell(phases[indexPath.section].classrooms[indexPath.row].name, profileImage: nil, index: indexPath.row)
            phaseCell.accessoryType = .None
            
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.phases[section].name
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
        }
    }
    func reloadData() {
        var classroomsBaby = [ClassroomMock]()
        classroomsBaby.append(ClassroomMock(name: "Tarde"))
        classroomsBaby.append(ClassroomMock(name: "Manhã"))
        phases.append(PhaseMock(name: "Berçário", classrooms: classroomsBaby))
        phases.append(PhaseMock(name: "Pré-Escola", classrooms: classroomsBaby))
        phases.append(PhaseMock(name: "Ninão", classrooms: classroomsBaby))
    }

}
