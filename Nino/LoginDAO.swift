//
//  LoginDAO.swift
//  Nino
//
//  Created by Danilo Becke on 02/09/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class LoginDAO: NSObject {

    static let sharedInstance = LoginDAO()
    
    override private init() {
        super.init()
    }
    
    func logout(completionHandler: (out: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.deleteAll()
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(out: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(out: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
}
