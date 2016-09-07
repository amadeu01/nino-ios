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
    
    private override init() {
        super.init()
    }
    
    static func getAllRooms(completionHandler: (rooms: () throws -> [Room]) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue(), {
            do {
                let realm = try Realm()
                var classrooms = [Room]()
                let objects = realm.objects(RoomRealmObject.self)
                for object in objects {
                    let room = Room(id: object.id, roomID: object.roomID.value, phaseID: object.phase!.id, name: object.name)
                    classrooms.append(room)
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(rooms: { () -> [Room] in
                        return classrooms
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
    
    static func getRoomsForPhase(phase: String, completionHandler: (rooms: () throws -> [Room]) -> Void) {
        var phaseClassrooms = [Room]()
        dispatch_async(RealmManager.sharedInstace.getRealmQueue(), {
            do {
                let realm = try Realm()
                let objects = realm.objects(RoomRealmObject.self)
                var classrooms = [Room]()
                for object in objects {
                    let room = Room(id: object.id, roomID: object.roomID.value, phaseID: object.phase!.id, name: object.name)
                    classrooms.append(room)
                }
                for room in classrooms {
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
    
    static func createRooms(rooms: [Room], completionHandler: (write: () throws -> Void) -> Void) {
        
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
    
    static func updateRoomID(room: String, roomID: Int, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let selectedRealmRoom = realm.objectForPrimaryKey(RoomRealmObject.self, key: room)
                guard let realmRoom = selectedRealmRoom else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(update: {
                            RealmError.CouldNotCreateRealm
                        })
                    })
                    return
                }
                try realm.write({
                    realmRoom.roomID.value = roomID
                    realm.add(realmRoom, update: true)
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
    
    static func getIdForRoom(roomID: String, completinHandler: (get: () throws -> Int) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let room = realm.objectForPrimaryKey(RoomRealmObject.self, key: roomID)
                guard let realmRoom = room else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completinHandler(get: { () -> Int in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let optionalID = realmRoom.roomID.value
                guard let id = optionalID else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completinHandler(get: { () -> Int in
                            throw DatabaseError.MissingID
                        })
                    })
                    return
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completinHandler(get: { () -> Int in
                        return id
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completinHandler(get: { () -> Int in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getLocalIdForRoom(roomID: Int, completionHandler: (get: () throws -> String) -> Void) {
        let filter = NSPredicate(format: "roomID = %d", roomID)
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let rooms = realm.objects(RoomRealmObject.self)
                let possibleRooms = rooms.filter(filter)
                let room = possibleRooms.first
                guard let realmRoom = room else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(get: { () -> String in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let id = realmRoom.id
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
    
    static func getRoomWithID(roomID: String, completionHandler: (getRoom: () throws -> Room) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let realmRoom = realm.objectForPrimaryKey(RoomRealmObject.self, key: roomID)
                guard let room = realmRoom else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(getRoom: { () -> Room in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let roomVO = Room(id: room.id, roomID: room.roomID.value, phaseID: room.phase!.id, name: room.name)
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(getRoom: { () -> Room in
                        return roomVO
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(getRoom: { () -> Room in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
}
