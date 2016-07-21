//
//  ManageStudentInfoViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/19/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
struct GuardiansMock {
    var name: String?
    var id: Int?
}
struct StudentInfoMock {
    var title: String?
    var value: String?
}
class ManageStudentInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
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
    var guardians = [GuardiansMock]()
    var studentInfos = [StudentInfoMock]()
    var extraSection = [String]()
    //Global constants
    let studentInfoSec = 0
    let guardianInfoSec = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        updateStudentInfo()
        updateGuardiansInfo()
        updateExtraSection()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.scrollEnabled = false
        self.addNinoDefaultBackGround()
        tableView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        widthOfContainerView.constant = self.view.frame.width
        heightOfContentView.constant = tableView.contentSize.height + distanceTopTableToTopSuperView.constant + 30
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateStudentInfo() {
        studentInfos.append(StudentInfoMock(title: "Nome", value: "Abélia Cristina Souza"))
        studentInfos.append(StudentInfoMock(title: "Data de Nascimento", value: "18 de Outubro de 2015"))
        studentInfos.append(StudentInfoMock(title: "Gênero", value: "Menina"))
    }
    func updateGuardiansInfo() {
        guardians.append(GuardiansMock(name: "João Augusto", id: 1))
        guardians.append(GuardiansMock(name: "Priscila Souza", id: 2))
        guardians.append(GuardiansMock(name: "Tia Irma", id: 3))
        guardians.append(GuardiansMock(name: "Vovó", id: 4))
        
    }
    func updateExtraSection() {
        extraSection.append("Adicionar Responsável")
        extraSection.append("Alterar Turma")
        extraSection.append("Excluir Cadastro")
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
                cell.userInteractionEnabled = false
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
            return "Responsáveis"
        }
        return nil
    }
    //MARK: Table View Delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {//Deletes the blank space below the cell
        if section == studentInfoSec {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35)
            guard let headerView  = StudentInfoSectionTableViewHeader.instanceFromNib() else {
                return nil
            }
        headerView.frame = frame
        headerView.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
        return headerView
        }
        //Clear Background
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
        let headerView  = UIView(frame: frame)
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == studentInfoSec {
            cell.detailTextLabel?.text = studentInfos[indexPath.row].value
            cell.textLabel?.text = studentInfos[indexPath.row].title
        } else if indexPath.section == guardianInfoSec {
            guard let guardianCell = cell as? GuardianTableViewCell else {
                return
            }
            guardianCell.configureCell(guardians[indexPath.row].name, profileImage: nil, index: indexPath.row)
        } else {
            cell.textLabel?.text = extraSection[indexPath.section - 2]
            print("Numero \(indexPath.section - 2)")
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentInfoSec {
            return 50
        }
        return 70
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == studentInfoSec {
            return 50
        }
        return 70
    }

}
