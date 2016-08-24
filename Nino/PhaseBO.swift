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
    static func createPhase(token: String, schoolID: String, name: String, completionHandler: (phase: () throws -> Phase) -> Void) {
        SchoolBO.getIdForSchool { (id) in
            do {
                let school = try id()
                
                var newPhase = Phase(id: StringsMechanisms.generateID(), phaseID: nil, name: name)
                
                PhaseDAO.sharedInstance.createPhases([newPhase], schoolID: schoolID, completionHandler: { (write) in
                    do {
                        try write()
                        PhasesMechanism.createPhase(token, schoolID: school, name: name) { (id, error, data) in
                            if let error = error {
                                //TODO: handle error data
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(phase: { () -> Phase in
                                        throw ErrorBO.decodeServerError(error)
                                    })
                                })
                            } else if let phaseID = id {
                                PhaseDAO.sharedInstance.updatePhaseId(newPhase.id, phaseID: phaseID, completionHandler: { (update) in
                                    do {
                                        try update()
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            completionHandler(phase: { () -> Phase in
                                                return Phase(id: newPhase.id, phaseID: phaseID, name: newPhase.name)
                                            })
                                        })
                                    } catch let err {
                                        //TODO: update phaseID error
                                    }
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(phase: { () -> Phase in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                            }
                        }

                    } catch let err {
                        //TODO: realm create phase error
                    }
                })
            } catch {
                //TODO: waiting getIdForSchool error handling
            }
        }
    }
    
    static func getPhases(token: String, schoolID: String, completionHandler: (phases: () throws -> [Phase]) -> Void) {
        SchoolBO.getIdForSchool { (id) in
            do {
                let school = try id()
                PhaseDAO.sharedInstance.getPhases({ (phases) in
                    do {
                        let localPhases = try phases()
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(phases: { () -> [Phase] in
                                return localPhases
                            })
                        })
                        PhasesMechanism.getPhases(token, schoolID: school, completionHandler: { (info, error, data) in
                            if let errorType = error {
                                //TODO: Handle error data and code
                                let error = NotificationMessage()
                                error.setServerError(ErrorBO.decodeServerError(errorType))
                                dispatch_async(dispatch_get_main_queue(), { 
                                    NinoNotificationManager.sharedInstance.addPhasesWereUpdatedNotification(self, error: error, info: nil)
                                })
                            } else if let phasesInfo = info {
                                var serverPhases = [Phase]()
                                for dict in phasesInfo {
                                    let phaseID = dict["id"] as? Int
                                    let phaseName = dict["name"] as? String
                                    let phaseMenu = dict["menu"] as? Int
                                    guard let id = phaseID else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            NinoNotificationManager.sharedInstance.addPhasesWereUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    guard let name = phaseName else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            NinoNotificationManager.sharedInstance.addPhasesWereUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    //TODO: save phaseMenu ids in somewhere
                                    let phase = Phase(id: StringsMechanisms.generateID(), phaseID: id, name: name)
                                    serverPhases.append(phase)
                                }
                                let comparison = self.comparePhases(serverPhases, localPhases: localPhases)
                                let wasChanged = comparison["wasChanged"]
                                let wasDeleted = comparison["wasDeleted"]
                                let newPhases = comparison["newPhases"]
                                if newPhases!.count > 0 {
                                    PhaseDAO.sharedInstance.createPhases(newPhases!, schoolID: schoolID, completionHandler: { (write) in
                                        do {
                                            try write()
                                            let message = NotificationMessage()
                                            message.setDataToInsert(newPhases!)
                                            dispatch_async(dispatch_get_main_queue(), { 
                                                NinoNotificationManager.sharedInstance.addPhasesWereUpdatedNotification(self, error: nil, info: message)
                                            })
                                        } catch {
                                            //TODO: handle realm error
                                        }
                                    })
                                }
                                //TODO: phase was deleted
                                //TODO: phase was updated
                            } else {
                                let error = NotificationMessage()
                                error.setServerError(ServerError.UnexpectedCase)
                                dispatch_async(dispatch_get_main_queue(), { 
                                    NinoNotificationManager.sharedInstance.addPhasesWereUpdatedNotification(self, error: error, info: nil)
                                })
                            }
                        })
                    } catch {
                       //TODO: realm and database error
                    }
                })
            } catch {
                //TODO: waiting getIdForSchool error handling
            }
        }
    }
    
    static func getIdForPhase(phase: String) throws -> Int {
        do {
            let id = try PhaseDAO.sharedInstance.getIdForPhase(phase)
            return id
        } catch let error {
            throw error
        }
    }
    
    static func getLocalIdForPhase(phaseID: Int) throws -> String {
        do {
            let id = try PhaseDAO.sharedInstance.getLocalIdForPhase(phaseID)
            return id
        } catch let error {
            throw error
        }
    }
    
    private static func comparePhases(serverPhases: [Phase], localPhases: [Phase]) -> [String: [Phase]] {
        var result = [String: [Phase]]()
        var wasChanged = [Phase]()
        var newPhases = [Phase]()
        var wasDeleted = [Phase]()
        //check all server phases
        for serverPhase in serverPhases {
            var found = false
            //look for its similar
            for localPhase in localPhases {
                //found
                if serverPhase.phaseID == localPhase.phaseID {
                    found = true
                    //updated
                    if serverPhase.name != localPhase.name {
                        wasChanged.append(serverPhase)
                    }
                    break
                }
            }
            //not found locally
            if !found {
                newPhases.append(serverPhase)
            }
        }
        for localPhase in localPhases {
            var found = false
            for serverPhase in serverPhases {
                if localPhase.phaseID == serverPhase.phaseID {
                    found = true
                    break
                }
            }
            if !found {
                wasDeleted.append(localPhase)
            }
        }
        
        result["newPhases"] = newPhases
        result["wasChanged"] = wasChanged
        result["wasDeleted"] = wasDeleted
        return result
    }
}
