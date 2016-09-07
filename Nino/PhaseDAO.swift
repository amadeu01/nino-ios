//
//  PhaseDAO.swift
//  Nino
//
//  Created by Danilo Becke on 22/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class PhaseDAO: NSObject {
    
    override private init() {
        super.init()
    }

    static func createPhases(phases: [Phase], schoolID: String, completionHandler: (write: () throws -> Void) -> Void) {
        
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let realmShool = realm.objectForPrimaryKey(SchoolRealmObject.self, key: schoolID)
                guard let school = realmShool else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(write: { 
                            throw DatabaseError.ConflictingIDs
                        })
                    })
                    return
                }
                var phasesArray = [PhaseRealmObject]()
                for phase in phases {
                    let newPhase = PhaseRealmObject()
                    newPhase.id = phase.id
                    newPhase.name = phase.name
                    newPhase.school = school
                    newPhase.phaseID.value = phase.phaseID
                    phasesArray.append(newPhase)
                }
                try realm.write({ 
                    for phase in phasesArray {
                        realm.add(phase)
                    }
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(write: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(write: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getPhases(completionHandler: (phases: () throws -> [Phase]) -> Void) {
        //database serach
        var phasesVO = [Phase]()
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let phases = realm.objects(PhaseRealmObject.self)
                for phase in phases {
                    let innerPhase = Phase(id: phase.id, phaseID: phase.phaseID.value, name: phase.name)
                    phasesVO.append(innerPhase)
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(phases: { () -> [Phase] in
                        return phasesVO
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(phases: { () -> [Phase] in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getPhaseWithID(phaseID: String, completionHandler: (getPhase: () throws -> Phase) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let realmPhase = realm.objectForPrimaryKey(PhaseRealmObject.self, key: phaseID)
                guard let phase = realmPhase else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(getPhase: { () -> Phase in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let phaseVO = Phase(id: phase.id, phaseID: phase.phaseID.value, name: phase.name)
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(getPhase: { () -> Phase in
                        return phaseVO
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(getPhase: { () -> Phase in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func updatePhaseId(phase: String, phaseID: Int, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let selectedRealmPhase = realm.objectForPrimaryKey(PhaseRealmObject.self, key: phase)
                guard let realmPhase = selectedRealmPhase else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(update: { 
                            RealmError.UnexpectedCase
                        })
                    })
                    return
                }
                try realm.write({
                    realmPhase.phaseID.value = phaseID
                    realm.add(realmPhase, update: true)
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(update: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(update: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getIdForPhase(phaseID: String, completionHandler: (get: () throws -> Int) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let phase = realm.objectForPrimaryKey(PhaseRealmObject.self, key: phaseID)
                guard let realmPhase = phase else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(get: { () -> Int in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let id = realmPhase.phaseID.value
                guard let idInt = id else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(get: { () -> Int in
                            throw DatabaseError.MissingID
                        })
                    })
                    return
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(get: { () -> Int in
                        return idInt
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(get: { () -> Int in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getLocalIdForPhase(phaseID: Int, completionHandler: (get: () throws -> String) -> Void) {
        let filter = NSPredicate(format: "phaseID = %d", phaseID)
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let phases = realm.objects(PhaseRealmObject.self)
                let possiblePhases = phases.filter(filter)
                let phase = possiblePhases.first
                guard let realmPhase = phase else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(get: { () -> String in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let id = realmPhase.id
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(get: { () -> String in
                        return id
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(get: { () -> String in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
}
