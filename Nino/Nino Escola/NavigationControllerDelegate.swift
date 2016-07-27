//
//  NavigationControllerDelegate.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/7/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
/// This Custom NAvigation controller was implemented primarely to handle custom segues transitions
class NavigationControllerDelegate: NSObject,
UINavigationControllerDelegate {
    
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

            if (fromVC as? RegisterNewEducatorViewController != nil) || (fromVC as? RegisterNewPhaseViewController != nil) || (fromVC as? RegisterNewClassroomViewController != nil) || (fromVC as? RegisterStudentViewController != nil) || (fromVC as? RegisterGuardianViewController != nil) {
                return GoDownAnimator()
            } else if (toVC as? RegisterNewEducatorViewController != nil) || (toVC as? RegisterNewPhaseViewController != nil) || (toVC as? RegisterNewClassroomViewController != nil) || (toVC as? RegisterStudentViewController != nil) || (toVC as? RegisterGuardianViewController != nil) {
                return ComeUpAnimator()
            }
        
        return nil //if other type of segue
}
}
class GoDownAnimator: NSObject,
UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.35
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
        return 0.35
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
