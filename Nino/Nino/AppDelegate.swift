//
//  AppDelegate.swift
//  Nino
//
//  Created by Danilo Becke on 19/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //states whether the user is logged in
    var loggedIn = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Mixpanel.initialize(token: "f86281849e415ef0d69aa6af9f80450b")
        
        IQKeyboardManager.sharedManager().enable = true
        self.setupRootViewController(false)
        
        return true
    }
    
    func setupRootViewController(animated: Bool) {
        
        if let window = self.window {
            var newRootViewController: UIViewController? = nil
            var transition: UIViewAnimationOptions
            
            // create and setup appropriate rootViewController
            if !loggedIn {
                if let loginViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("Login") as? GuardiansLoginViewController {
                    newRootViewController = loginViewController
                    transition = .TransitionFlipFromLeft
                } else {
                    transition = UIViewAnimationOptions.TransitionNone
                }
            } else {
                if let tabBarViewController = window.rootViewController!.storyboard!.instantiateInitialViewController() as? UITabBarController {
                    newRootViewController = tabBarViewController
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

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Got data! \(deviceToken)")
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        AccountBO.enableNotifications(tokenString, completionHandler: { (getStatus) in
            do {
                try getStatus()
            } catch {
                print("Something went wrong :(")
            }
        })
        print(tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Couldn't register :( \(error)")
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print("New Setting: \(notificationSettings)")
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
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
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        guard url.host == "register" else {
            return false
        }
        
        let navController = window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("passwordNavigation") as? UINavigationController
        window?.rootViewController = navController
        let viewController = navController?.viewControllers[0] as? GuardiansConfirmEmailViewController
        let token = url.query?.componentsSeparatedByString("=").last
        viewController?.isValidHash(token!)
        return true
    }


}
