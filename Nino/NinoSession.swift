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
    var credential: Credential? {
        return _credential
    }
    
    private override init () {
        super.init()
    }
    
    func setCredential(credential: Credential) {
        self._credential = credential
    }
    
}
