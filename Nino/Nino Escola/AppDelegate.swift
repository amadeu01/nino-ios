//
//  AppDelegate.swift
//  Nino Escola
//
//  Created by Danilo Becke on 19/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //states whether the user is logged in
    var loggedIn = true


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.sharedManager().enable = true
        self.setupRootViewController(false)
        //disabling toolbar in some views
        IQKeyboardManager.sharedManager().disableToolbarInViewControllerClass(CreateUserViewController)
        IQKeyboardManager.sharedManager().disableToolbarInViewControllerClass(CreateSchoolViewController)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupRootViewController(animated: Bool) {
        
        if let window = self.window {
            var newRootViewController: UIViewController? = nil
            var transition: UIViewAnimationOptions
            
            // create and setup appropriate rootViewController
            if !loggedIn {
                if let loginViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("Login") as? LoginViewController {
                    newRootViewController = loginViewController
                    transition = .TransitionFlipFromLeft
                } else {
                    transition = UIViewAnimationOptions.TransitionNone
                }
            } else {
                if let splitViewController = window.rootViewController!.storyboard!.instantiateInitialViewController() as? UISplitViewController {
                    newRootViewController = splitViewController
                    transition = .TransitionFlipFromRight
                } else {
                    transition = UIViewAnimationOptions.TransitionNone
                }
            }
            // update app's rootViewController
            if let rootVC = newRootViewController {
                if animated {
                    UIView.transitionWithView(window, duration: 0.5, options: transition, animations: { 
                        window.rootViewController = rootVC
                        }, completion: nil)
                } else {
                    window.rootViewController = rootVC
                }
            }
        }
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        var viewController: UIViewController?
        //block to be always executed before leaving the method
        defer {
            (viewController as? ConfirmEmailViewController)?.registerPassword("da")
        }
        //tests the host
        guard url.host == "register" else {
            return false
        }
        //checks if the RegisterPasswordVC is being exhibited
        let navigation = window?.topMostController() as? UINavigationController
        guard let vc = navigation?.topViewController else {
            //at LoginVC
            let loginVC = window?.topMostController()
            loginVC?.performSegueWithIdentifier("createNewUser", sender: nil)
            (window?.topMostController() as? UINavigationController)?.viewControllers[0].performSegueWithIdentifier("waitEmail", sender: nil)
//            window?.currentViewController()?.performSegueWithIdentifier("waitEmail", sender: nil)
            viewController = self.window?.currentViewController()
            print(viewController?.className)
            return true
        }
        guard vc.isMemberOfClass(ConfirmEmailViewController) else {
            //at CreateUserVC
            vc.performSegueWithIdentifier("waitEmail", sender: nil)
            viewController = window?.currentViewController()
            return true
        }
        //at ConfirmEmailVC
        viewController = vc
        return true
    }
}

extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).componentsSeparatedByString(".").last!
    }
}
