//
//  AnnouncementTableViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/25/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

enum AnnouncementType{
    case Draft
    case Sent
}

public class AnnouncementInfo: NSObject{
    var key:String?
    var body: String?
    var title: String?
    var date: NSDate!
    var index:Int?
    var announcementType: AnnouncementType!
    
    init(key: String!,  body: String?, title: String?, date: NSDate!, index: Int?, type: AnnouncementType!){
        self.key = key
        self.body = body
        self.title = title
        self.date = date
        self.index = index
        self.announcementType = type
    }
}

class AnnouncementTableViewController: UITableViewController, DraftAnnouncementDelegate {
    
    //@IBOutlet weak var emptyStateImage: UIImageView!
    var announcements = NSMutableArray()
    var keyMockGen = 0
    var selectedAnnouncementKey: String?
    //let thisRefreshControl = UIRefreshControl()
    let thisRefreshControl = UIRefreshControl()
    @IBOutlet weak var announcementsTableView: UITableView!
    //    let studentNameList = ["Danilo Becke","Amadeu Cavalcante", "Carlos Eduardo"]
    let announcementCellIdentifier = "announcementTableViewCell"// Reusable identifer
    // var demoAnnouncements = [Announcement]()
    
    var selectedCellTag: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        announcementsTableView.separatorStyle = .None
        announcementsTableView.tableFooterView = UIView(frame: CGRect.zero)// Removes empty cells
        thisRefreshControl.addTarget(self, action: #selector(reloadData), forControlEvents: UIControlEvents.ValueChanged)
        announcementsTableView.addSubview(thisRefreshControl)
        //announcementsTableView.addSubview(emptyStateImage)
        //announcementsTableView.backgroundView = emptyStateImage
        thisRefreshControl.beginRefreshing()
        //let longPress = UILongPressGestureRecognizer(target:self, action: #selector(handleLongPess))
        //Reoad dataa
        self.reloadData()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    func presentNoAnnouncementsEmptyState (b: Bool){
        self.announcementsTableView.backgroundView?.hidden = !b
    }
    func reloadAnnouncementsInMainThread(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            print("Will announcements in the tableView (if there are any)")
            self.sortAnnouncements()
            self.announcementsTableView.reloadData()
            self.thisRefreshControl.endRefreshing()
        })
    }
    //MARK: Reload Data
    func reloadData(){
        let key = "sampleKey"
        let body = "Hi there"
        let title = "Sample"
        let date = NSDate()
        let type = AnnouncementType.Draft
        
        self.announcements.addObject(AnnouncementInfo(key: key, body: body, title: title, date: date, index: 0, type: type))
        
        self.reloadAnnouncementsInMainThread()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: TabeView Data Source
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.announcementsTableView.dequeueReusableCellWithIdentifier(announcementCellIdentifier) as? AnnouncementTableViewCell
        if cell == nil{
            cell = AnnouncementTableViewCell()
        }
        
        cell?.addLongPressGesture({ (gesture) in
            self.userPressedDeleteAnnouncement(((self.announcements[indexPath.row] as? AnnouncementInfo)?.key)!, completionHandler: { (confirmation) in
                if confirmation {
                    
                } else{
                    
                }
            })
        })
        return cell!
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let thisCell = cell as? AnnouncementTableViewCell else {
            return
        }
        guard let currentAnnouncement = announcements[indexPath.row] as? AnnouncementInfo else {
            return
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        thisCell.dateLabel.text = dateFormatter.stringFromDate(currentAnnouncement.date)
        thisCell.tag = indexPath.row// Tags the cell so we know when it gets selected. TODO: Fix tag.
        thisCell.announcementTitle.text = currentAnnouncement.title
        if (currentAnnouncement.title == nil || currentAnnouncement.title == ""){
            thisCell.withTitle(false)
        }else{
            thisCell.withTitle(true)
        }
        
        currentAnnouncement.index = indexPath.row// TODO: Check whether this is useful.
        
        if currentAnnouncement.announcementType == AnnouncementType.Draft{
            thisCell.sentAnnouncement(false)
        }else {
            thisCell.sentAnnouncement(true)// Shows the draft symbol if the announcement is a draft and gives a boolean value
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfAnnouncements = announcements.count
        if numberOfAnnouncements == 0 {
            presentNoAnnouncementsEmptyState(true)
        }else{
            presentNoAnnouncementsEmptyState(false)
        }
        return announcements.count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    //MARK: TableView Delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
        
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
        
    }
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        print("didHighlightRowAtIndexPath")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openAnnouncement(indexPath.row)
    }
    func openAnnouncement(index: Int!){
        guard let announcement = announcements[index] as? AnnouncementInfo else {
            return
        }
        if announcement.announcementType == AnnouncementType.Draft{
            self.performSegueWithIdentifier("draftAnnouncement", sender: announcement)
        }else if announcement.announcementType == AnnouncementType.Sent{
            self.performSegueWithIdentifier("sentAnnouncement", sender: announcement)
        }
    }
    //MARK: - Select Cell
    func selectAndMoveToCellAtIndex(index: Int!){
        announcementsTableView.selectRowAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: true, scrollPosition: .Top)
        openAnnouncement(index)
    }
    //MARK: - New announcement
    func didPressNewAnnouncement(button: UIButton, indicator: UIActivityIndicatorView){
        
        self.announcementsTableView.beginUpdates()
        let key = generateKey()
        let date = NSDate()
        let newDraft = AnnouncementInfo(key: key, body: "", title: "", date: date, index: 0, type: .Draft)
        self.announcements.insertObject(newDraft, atIndex: 0)
        self.announcementsTableView.insertRowsAtIndexPaths( [NSIndexPath(forItem: 0, inSection: 0) ]   , withRowAnimation: UITableViewRowAnimation.Right)
        self.announcementsTableView.endUpdates()
        self.announcementsTableView.selectRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: .Top)//Selects the editable row
        self.performSegueWithIdentifier("draftAnnouncement", sender: newDraft)
    }
    // MARK: - Delete Cell
    func userPressedDeleteAnnouncement(key: String, completionHandler: (confirmation: Bool) -> Void){
        let alertView = UIAlertController(title: "Deseja apagar a mensagem?",message: "" as String, preferredStyle:.Alert)
        let deleteAction = UIAlertAction(title: "Apagar", style: UIAlertActionStyle.Destructive) { (delete) -> Void in
            
            completionHandler(confirmation: true)//user confirmed he wants to delete announcement
        }
        let deletedIndex = self.getIndexFromKey(key)
        //Delete visually
        self.announcements.removeObjectAtIndex(deletedIndex!)
        self.announcementsTableView.beginUpdates()
        self.announcementsTableView.deleteRowsAtIndexPaths([NSIndexPath(forItem: deletedIndex!, inSection: 0)], withRowAnimation: .Automatic)
        self.announcementsTableView.endUpdates()
        
        if(self.selectedAnnouncementKey == key){//Means we are showing the announcement that was deleted
            self.performSegueWithIdentifier("emptyState", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) { (cancel) -> Void in
            completionHandler(confirmation: false)
        }
        alertView.addAction(deleteAction)
        alertView.addAction(cancelAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    //MARK: Cell Editing
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // userPressedDeleteAnnouncement((announcements[indexPath.row] as! AnnouncementInfo).key!, completionHandler: )
        guard let selectedAnnouncement = announcements[indexPath.row] as? AnnouncementInfo else {
            return
        }
        
        //func deleteDraft(title: String!, body: String!, key: String!, completionHandler: (confirmation:Bool) -> Void)
        self.userPressedDeleteAnnouncement(selectedAnnouncement.key!) { (confirmation) -> Void in
            if confirmation{
                print("User confirmed the announcement should be deleted")
            }else{
                print("User confirmed the announcement should NOT be deleted")
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    // MARK: - Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier != "emptyState"{
            
            guard let selectedAnnouncement = sender as? AnnouncementInfo else {
                return
            }
            selectedAnnouncementKey = selectedAnnouncement.key
            if segue.identifier == "sentAnnouncement"{
                guard let navController = segue.destinationViewController as? DraftNavigationController else {
                    return
                }
                guard let controller = navController.viewControllers[0] as? SentAnnouncementViewController else {
                    return
                }
                controller.announcementText = selectedAnnouncement.body!
                controller.announcementTitle = selectedAnnouncement.title!
                
            }
            if segue.identifier == "draftAnnouncement"{
                guard let navController = (segue.destinationViewController as? DraftNavigationController) else {
                    return
                }
                guard let controller = navController.viewControllers[0] as? DraftAnnouncementViewController else {
                    return
                }
                controller.announcementText = selectedAnnouncement.body!
                controller.key = selectedAnnouncement.key!
                controller.delegate = self
                controller.announcementTitle = selectedAnnouncement.title!
                
                //  controller.delegate = self
                
            }
        }
    }
    //MARK: Announcements Helper
    func getIndexFromKey(key: String!) -> Int?{
        var index = 0
        for announcement in self.announcements{
            guard let thisAnnouncement = announcement as? AnnouncementInfo else {
                continue
            }
            if thisAnnouncement == key{
                return index
            }else{
                index += 1
            }
        }
        return nil// key not found
    }
    func sortAnnouncements(){
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        announcements.sortUsingDescriptors([sortDescriptor])
    }
    //MARK: DraftAnnouncementDelegate
    func saveDraft(title: String!, body: String!, key: String!) {
        print("Will save draft")
        
        print("Draft updated")
        let announcementIndex = self.getIndexFromKey(key)
        
        guard let updatedAnnouncement = self.announcements[announcementIndex!] as? AnnouncementInfo else {
            return
        }
        updatedAnnouncement.title = title
        updatedAnnouncement.body = body
        self.announcements.replaceObjectAtIndex(announcementIndex!, withObject: updatedAnnouncement)
        
        self.announcementsTableView.reloadRowsAtIndexPaths( [NSIndexPath(forItem: announcementIndex!, inSection: 0)], withRowAnimation: .Automatic)
    }
    func deleteDraft(title: String!, body: String!, key: String!, completionHandler: (confirmation: Bool) -> Void) {
        userPressedDeleteAnnouncement(key) { (confirmation) -> Void in
            completionHandler(confirmation: confirmation)
        }
    }
    func sendDraft(title: String!, body: String!, key: String!) {
        print("Now the announcement should be sent")
        let deletedAnnouncementKey = key
        
        //Delete announcement from the array
        let delIndex = self.getIndexFromKey(deletedAnnouncementKey)
        self.announcements.removeObjectAtIndex(delIndex!)
        let newKey = generateKey()
        let date = NSDate()
        self.announcements.insertObject(AnnouncementInfo(key: newKey, body: body, title: title, date: date, index: 0, type: .Sent), atIndex:0)
        self.announcementsTableView.beginUpdates()
        self.announcementsTableView.moveRowAtIndexPath(NSIndexPath(forItem: delIndex!, inSection: 0), toIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        self.announcementsTableView.endUpdates()
        self.announcementsTableView.beginUpdates()
        self.self.announcementsTableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.announcementsTableView.endUpdates()
        self.selectAndMoveToCellAtIndex(0)
        
        
        
    }
    func generateKey() -> String {//TODO: Erase this func.
        keyMockGen += 1
        return "\(keyMockGen)"
    }
}