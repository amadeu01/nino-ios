//
//  NinoSession.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 5/29/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class NinoSession: NSObject {
    
    static let sharedInstance = NinoSession()
    private var _credential: Credential?
    private var _educator: Educator?
    /// User credential, get only
    var credential: Credential? {
        return _credential
    }
    /// Active educator, get only
    var educator: Educator? {
        return _educator
    }
    
    private override init () {
        super.init()
    }
    
    /**
     Set user credential
     
     - parameter credential: new credential
     */
    func setCredential(credential: Credential) {
        self._credential = credential
    }
    
    /**
     Set active educator
     
     - parameter educator: active educator
     */
    func setEducator(educator: Educator) {
        self._educator = educator
    }
    
}
