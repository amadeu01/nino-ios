//
//  TimelineViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 8/12/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var studentsName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var currentPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MyDay", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "MyDay")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = CustomizeColor.lessStrongBackgroundNino().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        if let student = GuardiansSession.selectedStudent {
            studentsName.text = student.name + " " + student.surname
        }
        
        NinoNotificationManager.sharedInstance.addObserverForPostsUpdates(self, selector: #selector(postsUpdated))
        self.reloadData()
    }
    
    func reloadData() {
        self.currentPosts.removeAll()
        if let id = GuardiansSession.selectedStudent?.id {
            PostBO.getPostsForStudent(id) { (getPosts) in
                do {
                    let posts = try getPosts()
                    self.currentPosts = posts
                    self.tableView.reloadData()
                } catch {
                    //TODO:
                }
            }
        }
    }
    
    @objc func postsUpdated(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            //TODO:
            return
        }
        
        if let error = userInfo["error"] {
            //TODO:
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newPosts = message.dataToInsert as? [Post] {
                if newPosts.count > 0 {
                    reloadData()
                }
            }
        }
        
        //TODO: DELETED
        //TODO: UPDATED
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Configure cell
        guard let thisCell = cell as? MyDay else {
            return
        }
        
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier("showStudentProfile", sender: self)
    }
    //MARK: TableView Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MyDay") as? MyDay
        guard let thisCell = cell else {
            print("Could not find cell")
            return UITableViewCell()
        }
        let overview =  self.currentPosts[indexPath.item].message
        guard let date = self.currentPosts[indexPath.item].date else {
            print("No date")
            return UITableViewCell()
        }
        thisCell.fillCellWithFeed(date, overview: overview)
        return thisCell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPosts.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Only one section
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
