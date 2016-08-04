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
    var isSelected: Bool
    
    init(value: String, parent: IndentationCell?) {
        self.value  = value
        self.infoHier = 0
        self.isExpanded = false
        self.isSelected = false
        if let parent = parent {
            self.infoHier = parent.infoHier + 1
            if (parent.sons) != nil {//This parents already has sons
                parent.sons!.append(self)
            } else{
                parent.sons = [IndentationCell]()
                parent.sons!.append(self)
            }
        } else{ //No parent
            self.infoHier = 0
        }
    }
    func addSon(sons: [IndentationCell]) {
        self.sons = sons
        for son in sons {
            son.infoHier = self.infoHier + 1
        }
    }
    func setSelection(selected: Bool){
        self.isSelected = selected
        if let theseSons = self.sons {
            for son in theseSons{
                son.setSelection(selected)
            }
        }
    }
    func setExpansion(expanded: Bool) {
        self.isExpanded = expanded
        if let theseSons = self.sons {
            for son in theseSons {
                son.setSelection(expanded)
            }
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
        let result = whatsOn(indexPath.row, cells: indentationCells, level: 0)
        if let cellData = result.cell {
            cell.indentationLevel =  cellData.infoHier
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
        thisCell.checkBoxSelected = thisDataIndCell.isSelected
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
                    thisIndexWanted = a + result.membersLeft// fixes the index
                }
            }    //No sons, check next
                a += 1
            
        }
        //If it gets here, there are no more sons and we went over the limit
        return (nil, thisIndexWanted  - a + 1, level - 1) //+1
    }
    //MARK: Logic functions
    func loadData() {
        let firstCell = IndentationCell(value: "Pré Escola", parent: nil)
        let classroomA = IndentationCell(value: "Turma A", parent: firstCell)
        let classroomB = IndentationCell(value: "Turma B", parent: firstCell)
        let secondCell = IndentationCell(value: "Berçário", parent: nil)
        let classroom1 = IndentationCell(value: "Turma 1", parent: secondCell)
        let classroom2 = IndentationCell(value: "Turma 2", parent: secondCell)
        indentationCells.append(firstCell)
        indentationCells.append(secondCell)
        let p1 = IndentationCell(value: "João", parent: classroomB)
        let p2 = IndentationCell(value: "Mirna", parent: classroomB)
        let p3 = IndentationCell(value: "Flavio", parent: classroomB)
        
        let p11 = IndentationCell(value: "João", parent: p1)
        let p12 = IndentationCell(value: "Mirna", parent: p1)
        let p13 = IndentationCell(value: "Flavio", parent: p3)
        
        let b1 = IndentationCell(value: "João", parent: classroomA)
        let b2 = IndentationCell(value: "Mirna", parent: classroomA)
        let b3 = IndentationCell(value: "Flavio", parent: classroomA)
        
        let b11 = IndentationCell(value: "João", parent: b1)
        let b12 = IndentationCell(value: "Mirna", parent: b1)
        let b13 = IndentationCell(value: "Flavio", parent: b1)
        
        
        
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
            print("Error. Could not find index")
            return
        }
        let dataIndCell = whatsOn(index.row, cells: self.indentationCells, level: 0)
        let formerNumber = getNumberOfVisibleRows(self.indentationCells)
        dataIndCell.cell?.isExpanded = false
        guard let thisCell = dataIndCell.cell else {
            return //Cell should not be nill
        }
        thisCell.setExpansion(true)
        
        let currentNumber = getNumberOfVisibleRows(self.indentationCells)
        
        let dif = currentNumber - formerNumber
        var newPaths = [NSIndexPath]()
        if dif < 1 {
            print("Error Here")// Should not try to expand.
            return
        }
        for a in 1...dif {
            newPaths.append(NSIndexPath(forRow: a + index.row, inSection: 0))
        }
        self.classroomsTableView.beginUpdates()
        self.classroomsTableView.insertRowsAtIndexPaths(newPaths , withRowAnimation: UITableViewRowAnimation.Fade)
        self.classroomsTableView.endUpdates()
    }
    func didCollapse(cell: ExpandableSelectableTableViewCell) {
        //Cell should collapse
        //Cell was clicked. It has to expand.
        guard let index = self.classroomsTableView.indexPathForCell(cell) else {
            print("Error. Could not find index")
            return
        }
        let dataIndCell = whatsOn(index.row, cells: self.indentationCells, level: 0)
        let formerNumber = getNumberOfVisibleRows(self.indentationCells)
        dataIndCell.cell?.isExpanded = false
        guard let thisCell = dataIndCell.cell else {
            return //Cell should not be nill
        }
        thisCell.setExpansion(false)
        let currentNumber = getNumberOfVisibleRows(self.indentationCells)
        
        let dif = formerNumber - currentNumber
        var newPaths = [NSIndexPath]()
        if dif < 1 {
            print("Error Here")// Should not try to expand.
            return
        }
        for a in 1...dif {
            newPaths.append(NSIndexPath(forRow: a + index.row, inSection: 0))
        }
        self.classroomsTableView.beginUpdates()
        self.classroomsTableView.deleteRowsAtIndexPaths(newPaths , withRowAnimation: UITableViewRowAnimation.Fade)
        self.classroomsTableView.endUpdates()
    }
    func didSelect(cell: ExpandableSelectableTableViewCell) {
        //Should update
        guard let index = self.classroomsTableView.indexPathForCell(cell) else {
            print("Error. Could not find index")
            return
        }
        let dataIndCell = whatsOn(index.row, cells: self.indentationCells, level: 0)
        
        guard let selectedCell = dataIndCell.cell else {
            return //This should not happen. Error.
        }
        selectedCell.setSelection(true)// The data model is set-up. Now we should fix the view
        self.classroomsTableView.reloadData()
    }
    func didUnselect(cell: ExpandableSelectableTableViewCell) {
        guard let index = self.classroomsTableView.indexPathForCell(cell) else {
            print("Error. Could not find index")
            return
        }
        let dataIndCell = whatsOn(index.row, cells: self.indentationCells, level: 0)
        
        guard let selectedCell = dataIndCell.cell else {
            return //This should not happen. Error.
        }
        selectedCell.setSelection(false)// The data model is set-up. Now we should fix the view
        self.classroomsTableView.reloadData()
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
