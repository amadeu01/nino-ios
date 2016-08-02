//
//  ChooseClassroomsTableViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/29/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class IndentationCell {
    var value: String
    var sons: [IndentationCell]?
    var isExpanded: Bool
    var infoHier: Int
    
    convenience init(value: String, sons: [IndentationCell]?, isExpanded: Bool){
        self.init(value: value, sons: sons, isExpanded: isExpanded, infoHier: -1)
    }
    init(value: String, sons: [IndentationCell]?, isExpanded: Bool, infoHier: Int) {
        self.value = value
        self.sons = sons
        self.isExpanded = isExpanded
        self.infoHier = infoHier
    }
    
    func addSon(sons: [IndentationCell]){
        self.sons = sons
        for son in sons {
            son.infoHier = self.infoHier + 1
        }
    }
}

class ChooseClassroomsTableViewController: UITableViewController, ExpandableSelectableTableViewCellDelegate {

    @IBOutlet var classroomsTableView: UITableView!
    var indentationCells = [IndentationCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.classroomsTableView.tableFooterView =  UIView(frame: CGRect.zero)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getNumberOfVisibleRows(self.indentationCells)
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = classroomsTableView.dequeueReusableCellWithIdentifier("ExpandableSelectableTableViewCell", forIndexPath: indexPath) as? ExpandableSelectableTableViewCell else {
            print("Could not find identifier")
            return UITableViewCell()
        }
        //self.classroomsTableView.registerNib(UINib(nibName: "ExpandableSelectableTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandableSelectableTableViewCell")
        
        cell.delegate = self//Sets the delegate
        return cell
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let thisDataIndCell = whatsOn(indexPath.row, cells: indentationCells, level: 0).cell else {
            return
        }
        guard let thisCell = cell as? ExpandableSelectableTableViewCell else {
            return
        }
        thisCell.value = thisDataIndCell.value
        thisCell.infoHier = thisDataIndCell.infoHier
        //thisCell.delegate = self
        if thisDataIndCell.sons == nil {
            thisCell.hasSons = false
        } else {
            thisCell.hasSons = true
        }
        
    }
//    func getIndentationCellForIndexPath(index: NSIndexPath) -> IndentationCell?{
//        let rowIndex = index.row
//        if index < 0{
//            return nil // cannot have index less than 0
//        }
//        
//        let a = 0
//        
//        for thisCell in self.indentationCells{
//            if thisCell.isExpanded
//        }
//    }
    func whatsOn(indexWanted: Int, cells: [IndentationCell], level: Int) -> (cell: IndentationCell?, membersLeft: Int, level: Int) {
        var thisIndexWanted = indexWanted
        var a = 0
        while a < cells.count {// checks if exceeds
        //var numberOfSons = 0
            if a == thisIndexWanted {
                return (cells[a], 0, level)
            }
            //a += 1
            if cells[a].isExpanded {
                //need to go further
                guard let sons = cells[a].sons else {
                    break// should not happen
                }
                let result = whatsOn(thisIndexWanted - (a+1), cells: sons, level: 1 + level)
                if result.cell != nil {
                    //found it
                    return result
                } else {
                    thisIndexWanted -= result.membersLeft// fixes the index
                }
            }else {//No sons, check next
                a += 1
            }
        }
        //If it gets here, there are no more sons and we went over the limit
        return (nil, thisIndexWanted  - a, level - 1)
    }
    //MARK: Logic functions
    func loadData() {
        let classroomA = IndentationCell(value: "Turma A", sons: nil, isExpanded: false)
        let classroomB = IndentationCell(value: "Turma B", sons: nil, isExpanded: false)
        let firstCell = IndentationCell(value: "Pré Escola", sons: [classroomA, classroomB], isExpanded: false)
        self.indentationCells.append(firstCell)
        let classroom1 = IndentationCell(value: "Turma 1", sons: nil, isExpanded: false)
        let classroom2 = IndentationCell(value: "Turma 2", sons: nil, isExpanded: false)
        let secondCell = IndentationCell(value: "Berçário", sons: [classroom1, classroom2], isExpanded: false)
        self.indentationCells.append(secondCell)
    }
    func getNumberOfVisibleRows(indCells: [IndentationCell]) -> Int {
        var numberOfVisibleRows = 0
        for thisCell in indCells {
            numberOfVisibleRows += 1// Cell is expanded
            if thisCell.sons != nil && thisCell.isExpanded {
                numberOfVisibleRows += getNumberOfVisibleRows(thisCell.sons!)
            }
        }
        return numberOfVisibleRows
    }
    
    //MARK: ExpandableSelectableTableViewCellDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Do nothing
    }
    func didExpand(cell: ExpandableSelectableTableViewCell) {
        //Cell was clicked. It has to expand.
        guard let index = self.classroomsTableView.indexPathForCell(cell) else {
            print("Error. Could not find inde")
            return
        }
        let dataIndCell = whatsOn(index.row, cells: self.indentationCells, level: 0)
        let formerNumber = getNumberOfVisibleRows(self.indentationCells)
        dataIndCell.cell?.isExpanded = true
        let currentNumber = getNumberOfVisibleRows(self.indentationCells)
        
        let dif = currentNumber - formerNumber
        var newPaths = [NSIndexPath]()
        for a in 1...dif {
            newPaths.append(NSIndexPath(forRow: a + index.row, inSection: 0))
        }
        self.classroomsTableView.beginUpdates()
        self.classroomsTableView.insertRowsAtIndexPaths(newPaths , withRowAnimation: UITableViewRowAnimation.Fade)
        self.classroomsTableView.endUpdates()
    }
    func didCollapse(cell: ExpandableSelectableTableViewCell) {
        //Cell should collapse
    }
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
