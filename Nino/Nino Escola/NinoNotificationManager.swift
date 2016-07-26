//
//  NinoNotificationManager
//  Nino
//
//  Created by Danilo Becke on 18/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

private enum NinoNotifications {
    case SchoolUpdated
    case PhasesUpdated
    case PhasesFromServer
    
    func description() -> String {
        switch self {
        case .SchoolUpdated:
            return "SchoolUpdatedNotification"
        case .PhasesUpdated:
            return "PhasesUpdatedNotification"
        case .PhasesFromServer:
            return "ServerUpdatedNotification"
        }
    }
}

class NinoNotificationManager: NSObject {
    
    static let sharedInstance = NinoNotificationManager()
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    private override init() {
        super.init()
    }
    
    func addSchoolUpdatedNotification(sender: AnyObject?) {
        self.notificationCenter.postNotificationName(NinoNotifications.SchoolUpdated.description(), object: sender)
    }
    
    func addObserverForSchoolUpdates(observer: AnyObject, selector: Selector) {
        self.notificationCenter.addObserver(observer, selector: selector, name: NinoNotifications.SchoolUpdated.description(), object: nil)
    }
    
    func addPhasesUpdatedNotification(sender: AnyObject?) {
        self.notificationCenter.postNotificationName(NinoNotifications.PhasesUpdated.description(), object: sender)
    }
    
    func addObserverForPhasesUpdates(observer: AnyObject, selector: Selector) {
        self.notificationCenter.addObserver(observer, selector: selector, name: NinoNotifications.PhasesUpdated.description(), object: nil)
    }
    
    func addPhasesWereUpdatedFromServerNotification(sender: AnyObject?, error: AnyObject?, info: AnyObject?) {
        if let err = error {
            self.notificationCenter.postNotificationName(NinoNotifications.PhasesFromServer.description(), object: sender, userInfo: ["error": err])
        } else if let data = info {
            self.notificationCenter.postNotificationName(NinoNotifications.PhasesFromServer.description(), object: sender, userInfo: ["info": data])
        }
    }
    
    func addObserverForPhasesUpdatesFromServer(observer: AnyObject, selector: Selector) {
        self.notificationCenter.addObserver(observer, selector: selector, name: NinoNotifications.PhasesFromServer.description(), object: nil)
    }
}
