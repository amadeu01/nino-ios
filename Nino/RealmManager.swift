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
    
    private var realm: Realm?
    private let realmQueue = dispatch_queue_create("br.com.ninoapp.realmQueue", DISPATCH_QUEUE_CONCURRENT)
    private let defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    override private init() {
        super.init()
        do {
            self.realm = try Realm()
        } catch {
            //TODO: handle create Realm error
        }
    }
    
    func writeObjects(objects: [Object], completionHandler: (write: () throws -> Void) -> Void) {
        guard let realm = self.realm else {
            //TODO: throw realm error
            return
        }
        
        dispatch_async(self.realmQueue) {
            do {
                for object in objects {
                    try realm.write({
                        realm.add(object)
                    })
                }
                dispatch_async(self.defaultQueue, { 
                    completionHandler(write: { 
                        return
                    })
                })
            } catch {
                //TODO: throw creation error
            }
        }
        
        
    }
    
}
