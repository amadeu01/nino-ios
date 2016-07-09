//
//  ManageClassroomsNavigationControllerDelegate.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 7/8/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/// This Custom Navigation controller was implemented primarely to handle custom segues transitions for the Manage Classrooms View Controller
class ManageClassroomsNavigationControllerDelegate: NSObject,
UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if fromVC as? RegisterNewClassroomViewController != nil {
                return GoDownAnimator()

            } else if toVC as? RegisterNewClassroomViewController != nil {
                return ComeUpAnimator()
            }
        return ComeUpAnimator() //if other type of segue
    }
}
