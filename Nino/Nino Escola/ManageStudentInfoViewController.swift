//
//  ManageStudentInfoViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/19/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

struct StudentInfo {
    var title: String?
    var value: String?
}
class ManageStudentInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var heightOfContentView: NSLayoutConstraint!
    @IBOutlet weak var distanceTopTableToTopSuperView: NSLayoutConstraint!
    @IBOutlet weak var topDistanceToProfilePic: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scrolllView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    //Constraints
    @IBOutlet weak var widthOfContainerView: NSLayoutConstraint!
    
    // Global variables
    var mustReloadGuardians = false
    var guardians = [Guardian]()
    private var studentInfos = [StudentInfo]()
    private var extraSection = [String]()
    //Global constants
    private let studentInfoSec = 0
    private let guardianInfoSec = 1
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NinoNotificationManager.sharedInstance.addObserverForGuardiansUpdates(self, selector: #selector(guardiansUpdated))
        updateStudentInfo()
        updateExtraSection()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.scrollEnabled = false
        self.addNinoDefaultBackGround()
        tableView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        super.viewDidLayoutSubviews()
        widthOfContainerView.constant = self.view.frame.width
        heightOfContentView.constant = tableView.contentSize.height + distanceTopTableToTopSuperView.constant + 30
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateStudentInfo() {
        guard let selectedStudent = self.student else {
            //TODO: back to students
            return
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        studentInfos.append(StudentInfo(title: NSLocalizedString("PROF_NAME", comment: "Name"), value: selectedStudent.name + " " + selectedStudent.surname))
        studentInfos.append(StudentInfo(title: NSLocalizedString("PROF_BIRTHDATE", comment: "Birthdate"), value: formatter.stringFromDate(selectedStudent.birthDate)))
        studentInfos.append(StudentInfo(title: NSLocalizedString("PROF_GENDER", comment: "Gender"), value: selectedStudent.gender.description()))
        if let image = selectedStudent.profilePicture {
            self.profileImageView.image = UIImage(data: image)
        } else {
            self.profileImageView.image = UIImage(named: "icone-cadastrar-bebe")
        }
        self.studentName.text = selectedStudent.name + " " + selectedStudent.surname
        GuardianBO.getGuardiansForStudent(selectedStudent.id) { (getGuardians) in
            do {
                let guardians = try getGuardians()
                self.guardians.appendContentsOf(guardians)
                self.tableView.reloadSections(NSIndexSet(index: self.guardianInfoSec), withRowAnimation: UITableViewRowAnimation.Automatic)
            } catch let error {
                //TODO: handle error
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    @objc private func guardiansUpdated(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            //TODO: Unexpected case
            return
        }
        if let error = userInfo["error"] {
            //TODO: handle error
        } else if let message = userInfo["info"] as? NotificationMessage {
            if let newGuardians = message.dataToInsert as? [Guardian] {
                self.guardians.appendContentsOf(newGuardians)
                self.tableView.reloadSections(NSIndexSet(index: self.guardianInfoSec), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            //TODO: updated guardians
            //TODO: deleted guardians
        }
    }
    
    func updateExtraSection() {
        extraSection.append(NSLocalizedString("PROF_ADD_GUARDIAN", comment: "Add Guardian"))
        extraSection.append(NSLocalizedString("STU_CHANGE_ROOM", comment: "Change Room"))
        extraSection.append(NSLocalizedString("GENERAL_DELETE_REGISTER", comment: "Delete Register"))
    }
    
    //MARK: Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 + extraSection.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == studentInfoSec {
            return studentInfos.count
        } else if section == guardianInfoSec {
            return guardians.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == studentInfoSec {
            guard let studentInfoCell = tableView.dequeueReusableCellWithIdentifier("studentInfoCell") else {
                let cell = UITableViewCell(style: .Value1, reuseIdentifier: "studentInfoCell")
                //cell.userInteractionEnabled = false
                return cell
            }
            return studentInfoCell
        } else if indexPath.section == guardianInfoSec {
            guard let guardianInfoCell = tableView.dequeueReusableCellWithIdentifier("guardianTableViewCell") else {
                return UITableViewCell()
            }
            return guardianInfoCell
        }
        guard let extraCell = tableView.dequeueReusableCellWithIdentifier("extraSectionTableViewCell") else {
            return UITableViewCell()
        }
        print("Inside cellForRowAtIndex -> section \(indexPath.section - 2)")
        return extraCell
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("PROF_GUARDIANS", comment: "Guardians")
        }
        return ""
    }
    
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {//Deletes the blank space below the cell
        if section == studentInfoSec {
            let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80)
            guard let headerView  = StudentInfoSectionTableViewHeader.instanceFromNib() else {
                return nil
            }
            headerView.frame = frame
            headerView.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
            return headerView
        }
        return nil
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == studentInfoSec {
            return 40
        } else if section == guardianInfoSec {
            return 30
        }
        return 0
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = CustomizeColor.lessStrongBackgroundNino()
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
        let headerView  = UIView(frame: frame)
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == studentInfoSec {
            cell.detailTextLabel?.text = studentInfos[indexPath.row].value
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.text = studentInfos[indexPath.row].title
            cell.textLabel?.textColor = UIColor.grayColor()
        } else if indexPath.section == guardianInfoSec {
            guard let guardianCell = cell as? GuardianTableViewCell else {
                return
            }
            guardianCell.configureCell(guardians[indexPath.row].name, profileImage: nil, index: indexPath.row)
        } else {
            cell.textLabel?.text = extraSection[indexPath.section - 2]
            if indexPath.row == 0 {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            if indexPath.section == 4{
                cell.textLabel?.textColor = UIColor.redColor()
            }
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentInfoSec {
            return 40
        }
        return 70
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentInfoSec {
            return 40
        }
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            performSegueWithIdentifier("showRegisterGuardianViewController", sender: self)
        }
    }
    
    //MARK: NAvigation
    
    @IBAction func goBackToManageStudentInfoViewController(segue: UIStoryboardSegue) {
        if self.mustReloadGuardians {
            self.mustReloadGuardians = false
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRegisterGuardianViewController" {
            let vc = segue.destinationViewController as? RegisterGuardianViewController
            if let guardianVC = vc {
                guardianVC.studentID = self.student?.id
            }
        }
    }
    
}
