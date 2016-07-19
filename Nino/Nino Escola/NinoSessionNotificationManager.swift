//
//  NinoSessionNotificationManager.swift
//  Nino
//
//  Created by Danilo Becke on 18/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

private enum NinoSessionNotifications {
    case SchoolUpdated
    case PhasesUpdated
    
    func description() -> String {
        switch self {
        case .SchoolUpdated:
            return "SchoolUpdatedNotification"
        case .PhasesUpdated:
            return "PhasesUpdatedNotification"
        }
    }
}

class NinoSessionNotificationManager: NSObject {
    
    static let sharedInstance = NinoSessionNotificationManager()
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    private override init() {
        super.init()
    }
    
    func addSchoolUpdatedNotification(sender: AnyObject?) {
        self.notificationCenter.postNotificationName(NinoSessionNotifications.SchoolUpdated.description(), object: sender)
    }
    
    func addObserverForSchoolUpdates(observer: AnyObject, selector: Selector) {
        self.notificationCenter.addObserver(observer, selector: selector, name: NinoSessionNotifications.SchoolUpdated.description(), object: nil)
    }
    
    func addPhasesUpdatedNotification(sender: AnyObject?) {
        self.notificationCenter.postNotificationName(NinoSessionNotifications.PhasesUpdated.description(), object: sender)
    }
    
    func addObserverForPhasesUpdates(observer: AnyObject, selector: Selector) {
        self.notificationCenter.addObserver(observer, selector: selector, name: NinoSessionNotifications.PhasesUpdated.description(), object: nil)
    }
}
