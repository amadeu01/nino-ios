//
//  RoomDAO.swift
//  Nino
//
//  Created by Danilo Becke on 02/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class RoomDAO: NSObject {

    static let sharedInstance = RoomDAO()
    
    private var classrooms = [Room]()
    
    private override init() {
        super.init()
    }
    
    func getAllRooms(completionHandler: (rooms: () throws -> [Room]) -> Void) {
        if self.classrooms.count > 0 {
            completionHandler(rooms: { () -> [Room] in
                return self.classrooms
            })
        } else {
            dispatch_async(RealmManager.sharedInstace.getRealmQueue(), { 
                do {
                    let realm = try Realm()
                    let objects = realm.objects(RoomRealmObject.self)
                    for object in objects {
                        let room = Room(id: object.id, roomID: object.roomID.value, phaseID: object.phase!.id, name: object.name)
                        self.classrooms.append(room)
                    }
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(rooms: { () -> [Room] in
                            return self.classrooms
                        })
                    })
                } catch {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(rooms: { () -> [Room] in
                            throw RealmError.CouldNotCreateRealm
                        })
                    })
                }
            })
        }
    }
    
    func getRoomsForPhase(phase: String, completionHandler: (rooms: () throws -> [Room]) -> Void) {
        var phaseClassrooms = [Room]()
        if self.classrooms.count > 0 {
            for room in self.classrooms {
                if room.phaseID == phase {
                    phaseClassrooms.append(room)
                }
            }
            completionHandler(rooms: { () -> [Room] in
                return phaseClassrooms
            })
        } else {
            dispatch_async(RealmManager.sharedInstace.getRealmQueue(), { 
                do {
                    let realm = try Realm()
                    let objects = realm.objects(RoomRealmObject.self)
                    for object in objects {
                        let room = Room(id: object.id, roomID: object.roomID.value, phaseID: object.phase!.id, name: object.name)
                        self.classrooms.append(room)
                    }
                    for room in self.classrooms {
                        if room.phaseID == phase {
                            phaseClassrooms.append(room)
                        }
                    }
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(rooms: { () -> [Room] in
                            return phaseClassrooms
                        })
                    })
                } catch {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(rooms: { () -> [Room] in
                            throw RealmError.CouldNotCreateRealm
                        })
                    })
                }
            })
        }
    }
    
    func createRooms(rooms: [Room], completionHandler: (write: () throws -> Void) -> Void) {
        
        var roomsToAdd = rooms
        
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let phases = realm.objects(PhaseRealmObject.self)
                while roomsToAdd.count > 0 {
                    let phaseID = roomsToAdd.first!.phaseID
                    var i = 0
                    var roomsOfPhase = [Room]()
                    //get all rooms of the same phase
                    for room in roomsToAdd {
                        if room.phaseID == phaseID {
                            let thisRoom = roomsToAdd.removeAtIndex(i)
                            roomsOfPhase.append(thisRoom)
                            continue
                        }
                        i += 1
                    }
                    let phaseFilter = NSPredicate(format: "id == %@", phaseID)
                    let realmPhases = phases.filter(phaseFilter)
                    guard let phase = realmPhases.first else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(write: {
                                throw DatabaseError.ConflictingIDs
                            })
                        })
                        return
                    }
                    var roomsArray = [RoomRealmObject]()
                    for room in roomsOfPhase {
                        let classroom = RoomRealmObject()
                        classroom.id = room.id
                        classroom.name = room.name
                        classroom.roomID.value = room.roomID
                        classroom.phase = phase
                        roomsArray.append(classroom)
                    }
                    try realm.write({
                        for room in roomsArray {
                            realm.add(room)
                        }
                    })
                    for room in roomsOfPhase {
                        self.classrooms.append(room)
                    }
                } // while loop
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
            } //create realm catch
        } //realm queue
    }
    
}
