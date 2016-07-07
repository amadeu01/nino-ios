//
//  ManageEducatorsViewController.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/5/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class ManageEducatorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackgroundWithImage(UIImage(named: "backgroundBolas"))
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: TAbleView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure cell
        if indexPath.section == 0 {
            guard let newEducatorCell = tableView.dequeueReusableCellWithIdentifier("addNewEducator") else {
                print("Error inside ManageEducatorsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            newEducatorCell.backgroundColor = CustomizeColor.lessStrongBackgroundNino()
            return newEducatorCell
        } else {
            guard let educatorCell = tableView.dequeueReusableCellWithIdentifier("educatorProfileTableViewCell") else {
                print("Error inside ManageEducatorsViewController -> cellForRowAtIndexPath, cell identifier not found")
                return UITableViewCell()
            }
            educatorCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return educatorCell
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20)
        
        let headerView  = UIView(frame: frame)
        
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            // Configure add new educator cell
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            return 90
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            performSegueWithIdentifier("showRegisterNewEducatorViewController", sender: self)
            
        } else {
            self.performSegueWithIdentifier("showEducatorProfileViewController", sender: self)
        }
    }
    
    
    // MARK: Navigation
    
    @IBAction func cancelRegisterNewEducator(segue: UIStoryboardSegue) {
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        
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

class GoDownAnimator: NSObject,
UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(
        transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        containerView!.addSubview(toView)
        containerView!.sendSubviewToBack(toView)
        let currentFrame  = containerView!.bounds
        let bottomFrame = CGRect(x: 0, y: currentFrame.height, width: currentFrame.width, height: currentFrame.height)
        
        toView.frame = currentFrame
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration,
                                   animations: { fromView.frame = bottomFrame },
                                   completion: { finished in
                                    let cancelled = transitionContext.transitionWasCancelled()
                                    transitionContext.completeTransition(!cancelled) })
        
        
    }
}

class ComeUpAnimator: NSObject,
UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(
        transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        containerView!.addSubview(toView)
        
        let finalFrame  = containerView!.bounds
        let initalFrame = CGRect(x: 0, y: finalFrame.height, width: finalFrame.width, height: finalFrame.height)
        
        toView.frame = initalFrame
        
        let duration = transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration,
                                   animations: { toView.frame = finalFrame },
                                   completion: { finished in
                                    let cancelled = transitionContext.transitionWasCancelled()
                                    transitionContext.completeTransition(!cancelled) })
        
        
    }
}
class NavigationControllerDelegate: NSObject,
UINavigationControllerDelegate {
    
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.Pop {
            if fromVC as? RegisterNewEducatorViewController != nil {
                return GoDownAnimator()
            }
        } else if operation == UINavigationControllerOperation.Push {
            if toVC as? RegisterNewEducatorViewController != nil {
                return ComeUpAnimator()
            }
        }
        return nil //if other type of segue
    }
}
