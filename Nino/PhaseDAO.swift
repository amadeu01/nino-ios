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
    
    private var phases = [PhaseRealmObject]()
    
    override private init() {
        super.init()
    }

    func createPhase(phase: Phase, schoolID: String, completionHandler: (write: () throws -> Void) -> Void) {
        self.getSchool(schoolID) { (school, error) in
            if let err = error {
                completionHandler(write: { 
                    throw err
                })
            }
            guard let currentSchool = school else {
                completionHandler(write: { 
                    throw RealmError.UnexpectedCase
                })
            return
            }
            let newPhase = PhaseRealmObject()
            newPhase.id = phase.id
            newPhase.name = phase.name
            newPhase.school = currentSchool
            newPhase.phaseID.value = phase.phaseID
            RealmManager.sharedInstace.writeObjects([newPhase], completionHandler: { (write) in
                do {
                    try write()
                    self.phases.append(newPhase)
                    completionHandler(write: { 
                        return
                    })
                } catch let err {
                    completionHandler(write: { 
                        throw err
                    })
                }
            })
        }
    }
    
    func getPhases() -> [Phase] {
        var currentPhases = [Phase]()
        for phase in self.phases {
            let currentPhase = Phase(id: phase.id, phaseID: phase.phaseID.value, name: phase.name)
            currentPhases.append(currentPhase)
        }
        return currentPhases
    }
    
    func updatePhaseId(phase: String, phaseID: Int, completionHandler: (update: () throws -> Void) -> Void) {
        var phaseToUpdate: PhaseRealmObject?
        for phase in self.phases {
            if phase.id == phase {
                phaseToUpdate = phase
                break
            }
        }
        guard let selectedPhase = phaseToUpdate else {
            completionHandler(update: { 
                throw DatabaseError.NotFound
            })
            return
        }
        selectedPhase.phaseID.value = phaseID
        RealmManager.sharedInstace.writeObjects([selectedPhase]) { (write) in
            do {
                try write()
                completionHandler(update: { 
                    return
                })
            } catch let err {
                completionHandler(update: { 
                    throw err
                })
            }
        }
    }
    
    func getIdForPhase(phaseID: String) throws -> Int {
        for phase in self.phases {
            if phase.id == phaseID {
                guard let serverID = phase.phaseID.value else {
                    throw DatabaseError.MissingID
                }
                return serverID
            }
        }
        throw DatabaseError.NotFound
    }
    
    private func getSchool(id: String, completionHandler: (school: SchoolRealmObject?, error: ErrorType?) -> Void) {
        let filter = NSPredicate(format: "id == %@", id)
        RealmManager.sharedInstace.getObjects(SchoolRealmObject.self, filter: filter) { (retrieve) in
            do {
                let schools = try retrieve()
                guard let school = schools.first else {
                    completionHandler(school: nil, error: DatabaseError.NotFound)
                    return
                }
                completionHandler(school: school, error: nil)
            } catch let error {
                completionHandler(school: nil, error: error)
            }
        }
    }
}
