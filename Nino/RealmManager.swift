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
        dispatch_sync(self.realmQueue) { 
            do {
                self.realm = try Realm()
            } catch {
                self.realm = nil
            }
        }
    }
    
    func writeObjects(objects: [Object], completionHandler: (write: () throws -> Void) -> Void) {
        
        dispatch_async(self.realmQueue) {
            guard let realm = self.realm else {
                completionHandler(write: { 
                    throw RealmError.CouldNotCreateRealm
                })
                return
            }
            do {
                for object in objects {
                    try realm.write({
                        realm.add(object, update: true)
                    })
                }
                dispatch_async(self.defaultQueue, { 
                    completionHandler(write: { 
                        return
                    })
                })
            } catch {
                completionHandler(write: { 
                    throw RealmError.UnexpectedCase
                })
            }
        }
    }
    
    func getObjects<T>(objects: T.Type, filter: NSPredicate?, completionHandler: (retrieve: () throws -> Results<T>) -> Void) {

        dispatch_async(self.realmQueue) {
            guard let realm = self.realm else {
                completionHandler(retrieve: { () -> Results<T> in
                    throw RealmError.CouldNotCreateRealm
                })
                return
            }
            let results = realm.objects(objects)
            if let predicate = filter {
                dispatch_async(self.defaultQueue, { 
                    completionHandler(retrieve: { () -> Results<T> in
                        return results.filter(predicate)
                    })
                })
            } else {
                dispatch_async(self.defaultQueue, { 
                    return results
                })
            }
        }
    }
    
}
