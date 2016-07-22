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
    private var _educator: String?
    private var _school: String?
    /// User credential, get only
    var credential: Credential? {
        return _credential
    }
    /// Active educator, get only
    var educatorID: String? {
        return _educator
    }
    /// Active school, get only
    var schoolID: String? {
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
    func setEducator(educator: String) {
        self._educator = educator
    }
    
    /**
     Set active school
     
     - parameter school: active school
     */
    func setSchool(school: String) {
        self._school = school
    }
    
//    /**
//     Add phases for current school
//     
//     - parameter phases: array of phases
//     */
//    func addPhasesForSchool(phases: [Phase]) {
//        for phase in phases {
//            self._school?.phases?.append(phase)
//        }
//    }
//    
//    /**
//     Add a new room to the phase
//     
//     - parameter phaseID:   phase id
//     - parameter room:      new room
//     
//     - returns:             phase updated
//     */
//    func addRoomInPhase(phaseID: Int, room: Room) -> Phase? {
//        guard let phases = self._school?.phases else {
//            return nil
//        }
//        var i = 0
//        for phase in phases {
//            if phase.id == phaseID {
//                var currentPhase = phase
//                currentPhase.rooms?.append(room)
//                self._school?.phases?.removeAtIndex(i)
//                self._school?.phases?.insert(currentPhase, atIndex: i)
//                return currentPhase
//            }
//            i += 1
//        }
//        return nil
//    }
//    
//    func getPhaseById(id: Int) -> Phase? {
//        guard let phases = self._school?.phases else {
//            return nil
//        }
//        for phase in phases {
//            if phase.id == id {
//                return phase
//            }
//        }
//        return nil
//    }
    
}
