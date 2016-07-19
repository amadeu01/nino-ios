//
//  NinoSession.swift
//  Nino
//
//  Created by Alfredo Cavalcante Neto on 5/29/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

class NinoSession: NSObject {
    
    static let sharedInstance = NinoSession()
    private var _credential: Credential?
    private var _educator: Educator?
    private var _school: School?
    /// User credential, get only
    var credential: Credential? {
        return _credential
    }
    /// Active educator, get only
    var educator: Educator? {
        return _educator
    }
    /// Active school, get only
    var school: School? {
        return _school
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
    
    /**
     Set active school
     
     - parameter school: active school
     */
    func setSchool(school: School) {
        self._school = school
    }
    
    /**
     Add phases for current school
     
     - parameter phases: array of phases
     */
    func addPhasesForSchool(phases: [Phase]) {
        for phase in phases {
            self._school?.phases?.append(phase)
        }
    }
    
}
