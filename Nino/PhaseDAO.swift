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
    
    static let sharedInstance = PhaseDAO()
    
    private var phases = [Phase]()
    
    override private init() {
        super.init()
    }

    func createPhases(phases: [Phase], schoolID: String, completionHandler: (write: () throws -> Void) -> Void) {
        
        let schoolFilter = NSPredicate(format: "id == %@", schoolID)
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let schools = realm.objects(SchoolRealmObject.self)
                let realmSchools = schools.filter(schoolFilter)
                guard let school = realmSchools.first else {
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
                for phase in phases {
                    self.phases.append(phase)
                }
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
    
    func getPhases(completionHandler: (phases: () throws -> [Phase]) -> Void) {
        
        if self.phases.count > 0 {
            completionHandler(phases: { () -> [Phase] in
                return self.phases
            })
        } else {
            //database serach
            dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let phases = realm.objects(PhaseRealmObject.self)
                for phase in phases {
                    let innerPhase = Phase(id: phase.id, phaseID: phase.phaseID.value, name: phase.name)
                    self.phases.append(innerPhase)
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(phases: { () -> [Phase] in
                        return self.phases
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
    }
    
    func updatePhaseId(phase: String, phaseID: Int, completionHandler: (update: () throws -> Void) -> Void) {
        
        var phaseToUpdate: Phase?
        var position = 0
        for localPhase in self.phases {
            if localPhase.id == phase {
                phaseToUpdate = localPhase
                break
            }
            position += 1
        }
        
        guard var selectedPhase = phaseToUpdate else {
            completionHandler(update: {
                throw DatabaseError.NotFound
            })
            return
        }
        
        selectedPhase.phaseID = phaseID
        self.phases.removeAtIndex(position)
        self.phases.insert(selectedPhase, atIndex: position)
        let filter = NSPredicate(format: "id == %@", phase)
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let phases = realm.objects(PhaseRealmObject.self)
                let selectedPhases = phases.filter(filter)
                guard let realmPhase = selectedPhases.first else {
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
    
    func getIdForPhase(phaseID: String) throws -> Int {
        for phase in self.phases {
            if phase.id == phaseID {
                guard let serverID = phase.phaseID else {
                    throw DatabaseError.MissingID
                }
                return serverID
            }
        }
        throw DatabaseError.NotFound
    }
}
