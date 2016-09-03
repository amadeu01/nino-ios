//
//  RealmManager.swift
//  Nino
//
//  Created by Danilo Becke on 22/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {

    static let sharedInstace = RealmManager()
    
    private let realmQueue = dispatch_queue_create("br.com.ninoapp.realmQueue", DISPATCH_QUEUE_SERIAL)
    private let defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    override private init() {
        super.init()
    }
    
    func getRealmQueue() -> dispatch_queue_t {
        return self.realmQueue
    }
    
    func getDefaultQueue() -> dispatch_queue_t {
        return self.defaultQueue
    }
}
