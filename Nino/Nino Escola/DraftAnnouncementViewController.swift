//
//  DraftAnnouncementViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/25/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//


import UIKit

class DraftAnnouncementViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewThatHoldsTextView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    //    var text:String = ""
    //    var textTitle:String = ""
    
    var announcementText = ""
    var announcementTitle = ""
    var key = ""
    var announcementEdited =  false // boolean value that states whether the announcement was modified
    
    // Flag is set to true when user presses the trash. Therefore, if the user confirms the deletion
    //of a announcement, app will not attempt to auto-save the announcement when viewcontroller disappears.
    var announcementWillBeSent = false
    
    weak var delegate: DraftAnnouncementDelegate?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //saveButton.addTarget(self, action: "didPressSaveAnnouncement", forControlEvents: UIControlEvents.TouchUpInside)
        sendButton.addTarget(self, action: #selector(DraftAnnouncementViewController.didPressSendAnnouncement), forControlEvents: UIControlEvents.TouchUpInside)
        trashButton.addTarget(self, action: #selector(DraftAnnouncementViewController.didPressTrashAnnouncement), forControlEvents: UIControlEvents.TouchUpInside)
        
        saveButton.hidden = true
        saveButton.enabled = false
        
        if self.navigationItem.title == "" || self.navigationItem.title == nil {
            self.navigationItem.title = ""
        }
        
        
        //Updates the title and text, if announcement has been edited in the past
        self.titleTextField.text = self.announcementTitle
        self.navigationItem.title = self.announcementTitle
        
        self.textView.text = self.announcementText
        
        self.navigationBarColor = CustomizeColor.clearBackgroundNino()
        // Preloads keyboard so there's no lag on initial keyboard appearance.
        let lagFree = UITextField()
        self.view.addSubview(lagFree)
        lagFree.becomeFirstResponder()
        lagFree.resignFirstResponder()
        lagFree.removeFromSuperview()
        
        //Scrollview always scrollable
        scrollView.alwaysBounceVertical = true
        
        
        //Starts editing the text of user taps detailView
        viewThatHoldsTextView.addTapGesture(1, action: {(recognizer) -> Void in
            
            self.textView.becomeFirstResponder()
        })
        scrollView.addTapGesture(1, action: {(recognizer) -> Void in
            
            self.textView.becomeFirstResponder()
        })
        
        viewThatHoldsTextView.addTapGesture(2, action: {(recognizer) -> Void in
            
            self.textView.resignFirstResponder()
        })
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationItem.title == "" || self.navigationItem.title == nil {
            self.navigationItem.title = ""
        }
        announcementEdited = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("view will disappear")
        if(announcementEdited && !announcementWillBeSent){
            self.delegate?.saveDraft(titleTextField.text, body: textView.text, key: self.key)
        }
    }
    //MARK: Navigation Bar Button Handlers
    func didPressSendAnnouncement() {
        //TODO: Give it to delegate.
        announcementWillBeSent = true
        self.delegate?.sendDraft(titleTextField.text, body: textView.text, key: self.key)
        enableAllButtons(false)
        
        
    }
    
    func enableAllButtons(b: Bool){
        sendButton.enabled = b// TODO: completionHandler in delegate.
        trashButton.enabled = b
        saveButton.enabled = b
    }
    
    func didPressTrashAnnouncement() {
        // self.delegate?.deleteDraft(titleTextField.text, announcement: textView.text, key: self.key)
        enableAllButtons(false)
        self.delegate?.deleteDraft(titleTextField.text, body: textView.text, key: self.key, completionHandler: { (confirmation) -> Void in
            if !confirmation{
                self.enableAllButtons(true)
            }
        })
    }
    
    func didPressSaveAnnouncement(){
        self.delegate?.saveDraft(titleTextField.text, body: textView.text, key: self.key)
        
    }
    func addLeftBarButtonItem() {
        if self.splitViewController?.displayMode != UISplitViewControllerDisplayMode.AllVisible{
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "collapse"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(DraftAnnouncementViewController.didPressShowDetail))
        } else {
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "expand"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(DraftAnnouncementViewController.didPressExpand))
        }
    }
    func didPressShowDetail() {
        print("Should uncollapse")
        UIView.animateWithDuration(0.2) {
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        }
        
        print(self.splitViewController?.collapsed)
        addLeftBarButtonItem()
    }
    func didPressExpand() {
        print("Should expand")
        UIView.animateWithDuration(0.2) {
            self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
        }
        
        print(self.splitViewController?.collapsed)
        
        addLeftBarButtonItem()
    }
    @IBAction func didPressToAddSenders(sender: UIButton) {
        let storyboard = UIStoryboard(name: "ChooseClassroom", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ChooseClassroomsTableViewController")
        //let vc = UITableViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        presentViewController(vc, animated: true, completion: nil)
        let popover = vc.popoverPresentationController!
        popover.sourceView = sender
        popover.permittedArrowDirections = .Left
        popover.sourceRect = CGRect(x: sender.frame.width, y: sender.frame.height/2, width: sender.frame.width, height: sender.frame.height)
    }
    
    //MARK: UITextFieldDelegate
    
    //Starts editing the announcement once the user has typed the title
    func textFieldDidEndEditing(textField: UITextField) {
        self.textView.becomeFirstResponder()
        self.navigationItem.title = self.titleTextField.text
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.textView.becomeFirstResponder()
        self.navigationItem.title = self.titleTextField.text
        return true
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        announcementEdited = true
        UIColor.whiteColor()
        let a = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
}
//MARK: - Draft Delegate

protocol DraftAnnouncementDelegate: class {
    func saveDraft (title: String!, body: String!, key: String!)
    func deleteDraft(title: String!, body: String!, key: String!, completionHandler: (confirmation:Bool) -> Void)
    func sendDraft(title: String!, body: String!, key: String!)
}

