//
//  ProfileTopBarViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/1/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ProfileTopBarViewController: UIViewController {
    weak var delegate: StudentProfileNavigationController?
    
    @IBOutlet weak var myDayButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var activitiesButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var birthdate: UILabel!
    @IBOutlet weak var name: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDayButton.hidden = true
        photosButton.hidden = true
        activitiesButton.hidden = true
        chatButton.hidden = true
        // Do any additional setup after loading the view.
        
        if let studentID = SchoolSession.currentStudent {
            StudentBO.getStudentForID(studentID, completionHandler: { (student) in
                do {
                    let student = try student()
                    self.name.text = student.name + " " + student.surname
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    self.birthdate.text = "Nascimento: " + formatter.stringFromDate(student.birthDate)
                } catch {
                    //TODO: handle error
                }
            })
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CustomizeColor.borderColourNino()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func showMyDayViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showMyDayViewController", object: self)
    }
    @IBAction func showActivitiesViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showActivitiesViewController", object: self)
    }
    @IBAction func showPhotosViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showPhotosViewController", object: self)
    }
    @IBAction func showChatViewController(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("showChatViewController", object: self)
    }
    
    
   
    
    
}
