//
//  ManageClassroomsNavigationControllerDelegate.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/8/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/// This Custom NAvigation controller was implemented primarely to handle custom segues transitions for the Manage Classrooms View Controller
class ManageClassroomsNavigationControllerDelegate: NSObject,
UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Push {
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