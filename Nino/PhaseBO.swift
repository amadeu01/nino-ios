//
//  PhaseBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all sevices of phases
class PhaseBO: NSObject {

    /**
     Tries to create a Phase
     
     - parameter id:         unique identifier
     - parameter name:       phase's name
     - parameter rooms:      optional list of rooms
     - parameter menu:       optional menu
     - parameter activities: optional list of activities
     
     - returns: Phase VO
     */
    static func createPhase(token: String, schoolID: Int, name: String, rooms: [Room]?, menu: Menu?, activities: [Activity]?, completionHandler: (phase: () throws -> Phase) -> Void) {
        PhasesMechanism.createPhase(token, schoolID: schoolID, name: name) { (id, error, data) in
            if let error = error {
                //TODO: handle error data
                completionHandler(phase: { () -> Phase in
                    throw ErrorBO.decodeServerError(error)
                })
            } else if let phaseID = id {
                completionHandler(phase: { () -> Phase in
                    return Phase(id: phaseID, name: name, rooms: rooms, menu: menu, activities: activities)
                })
            } else {
                completionHandler(phase: { () -> Phase in
                    throw ServerError.UnexpectedCase
                })
            }
        }
    }
    
    static func getPhases(token: String, schoolID: Int, completionHandler: (phases: () throws -> [Phase]) -> Void) {
        PhasesMechanism.getPhases(token, schoolID: schoolID) { (info, error, data) in
            if let errorType = error {
                //TODO: Handle error data and code
                completionHandler(phases: { () -> [Phase] in
                    throw ErrorBO.decodeServerError(errorType)
                })
            } else if let phasesInfo = info {
                var phases = [Phase]()
                for dict in phasesInfo {
                    let phaseID = dict["id"] as? Int
                    let phaseName = dict["name"] as? String
                    let phaseMenu = dict["menu"] as? Int
                    guard let id = phaseID else {
                        completionHandler(phases: { () -> [Phase] in
                            throw ServerError.UnexpectedCase
                        })
                        return
                    }
                    guard let name = phaseName else {
                        completionHandler(phases: { () -> [Phase] in
                            throw ServerError.UnexpectedCase
                        })
                        return
                    }
                    //TODO: save phaseMenu ids in somewhere
                    let phase = Phase(id: id, name: name, rooms: nil, menu: nil, activities: nil)
                    phases.append(phase)
                }
                completionHandler(phases: { () -> [Phase] in
                    return phases
                })
            }
                //unexpected case
            else {
                completionHandler(phases: { () -> [Phase] in
                    throw ServerError.UnexpectedCase
                })
            }
        }
    }
}
