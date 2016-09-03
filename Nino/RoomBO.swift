//
//  RoomBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all sevices of phases
class RoomBO: NSObject {

    /**
     Tries to create a Room
     
     - parameter phase:      room's phase
     - parameter name:       room's name
     - parameter educators:  optional list of educators
     - parameter calendar:   optional calendar
     - parameter students:   optional list of students
     
     */
    static func createRoom(phaseID: String, name: String, completionHandler: (room: () throws -> Room) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            dispatch_async(dispatch_get_main_queue(), { 
                completionHandler(room: { () -> Room in
                    throw AccountError.InvalidToken
                })
            })
            return
        }
        PhaseBO.getIdForPhase(phaseID) { (id) in
            do {
                let phase = try id()
                let room = Room(id: StringsMechanisms.generateID(), roomID: nil, phaseID: phaseID, name: name)
                RoomDAO.createRooms([room]) { (write) in
                    do {
                        try write()
                        RoomMechanism.createRoom(token, classID: phase, roomName: name, completionHandler: { (roomID, error, data) in
                            if let error = error {
                                //TODO: handle error data
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(room: { () -> Room in
                                        throw ErrorBO.decodeServerError(error)
                                    })
                                })
                            } else if let roomID = roomID {
                                RoomDAO.updateRoomID(room.id, roomID: roomID, completionHandler: { (update) in
                                    do {
                                        try update()
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(room: { () -> Room in
                                                return Room(id: room.id, roomID: roomID, phaseID: room.phaseID, name: room.name)
                                            })
                                        })
                                    } catch {
                                        //TODO: handle realm error
                                    }
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(room: { () -> Room in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                            }
                        })
                    } catch {
                        //TODO: create room error
                    }
                }
            } catch let error {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(room: { () -> Room in
                        throw error
                    })
                })
            }
        }
    }
    
    static func getAllRooms(completionHandler: (rooms: () throws -> [Room]) -> Void) {
        RoomDAO.getAllRooms { (rooms) in
            do {
                //get local rooms
                let localRooms = try rooms()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(rooms: { () -> [Room] in
                        return localRooms
                    })
                })
                guard let token = NinoSession.sharedInstance.credential?.token else {
                    dispatch_async(dispatch_get_main_queue(), { 
                        completionHandler(rooms: { () -> [Room] in
                            throw AccountError.InvalidToken
                        })
                    })
                    return
                }
                SchoolBO.getIdForSchool({ (id) in
                    do {
                        let schoolID = try id()
                        var serverRooms = [Room]()
                        //get rooms for all phases
                        RoomMechanism.getAllRooms(token, schoolID: schoolID, completionHandler: { (info, error, data) in
                            if let errorType = error {
                                //TODO: handle error data and code
                                let message = NotificationMessage()
                                message.setServerError(ErrorBO.decodeServerError(errorType))
                                dispatch_async(dispatch_get_main_queue(), {
                                    NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                })
                            } else if let roomsInfo = info {
                                for dict in roomsInfo {
                                    let id = dict["roomID"] as? Int
                                    let name = dict["name"] as? String
                                    let phaseID = dict["phaseID"] as? Int
                                    guard let roomID = id else {
                                        let message = NotificationMessage()
                                        message.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                        })
                                        return
                                    }
                                    guard let roomName = name else {
                                        let message = NotificationMessage()
                                        message.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                        })
                                        return
                                    }
                                    guard let phase = phaseID else {
                                        let message = NotificationMessage()
                                        message.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                        })
                                        return
                                    }
                                    PhaseBO.getLocalIdForPhase(phase, completionHandler: { (id) in
                                        do {
                                            let localPhaseID = try id()
                                            let room = Room(id: StringsMechanisms.generateID(), roomID: roomID, phaseID: localPhaseID, name: roomName)
                                            serverRooms.append(room)
                                        } catch {
                                            //TODO: phase not found error
                                        }
                                    })
                                } // end loop
                                let comparison = self.compareRooms(serverRooms, localRooms: localRooms)
                                let wasChanged = comparison["wasChanged"]
                                let wasDeleted = comparison["wasDeleted"]
                                let newRooms = comparison["newRooms"]
                                if newRooms!.count > 0 {
                                    RoomDAO.createRooms(newRooms!, completionHandler: { (write) in
                                        do {
                                            try write()
                                            let message = NotificationMessage()
                                            message.setDataToInsert(newRooms!)
                                            dispatch_async(dispatch_get_main_queue(), {
                                                NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: nil, info: message)
                                            })
                                        } catch {
                                            //TODO: handle couldNotCreateRealm
                                        }
                                    })
                                }
                                //TODO: rooms were updated
                                //TODO: rooms were deleted
                            }
                        })
                        
                    } catch {
                        //getidschool error
                    }
                })
            } catch {
                //TODO: handle couldNotCreateRealm
            }
        }
    }
    
    static func getRooms(phaseID: String, completionHandler: (rooms: () throws -> [Room]) -> Void) {
        
        RoomDAO.getRoomsForPhase(phaseID) { (rooms) in
            do {
                let localRooms = try rooms()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(rooms: { () -> [Room] in
                        return localRooms
                    })
                })
                guard let token = NinoSession.sharedInstance.credential?.token else {
                    dispatch_async(dispatch_get_main_queue(), { 
                        completionHandler(rooms: { () -> [Room] in
                            throw AccountError.InvalidToken
                        })
                    })
                    return
                }
                PhaseBO.getIdForPhase(phaseID, completionHandler: { (id) in
                    do {
                        let phase = try id()
                        RoomMechanism.getRooms(token, classID: phase, completionHandler: { (info, error, data) in
                            if let errorType = error {
                                //TODO: Handle error data and code
                                dispatch_async(dispatch_get_main_queue(), {
                                    let message = NotificationMessage()
                                    message.setServerError(ErrorBO.decodeServerError(errorType))
                                    NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                })
                            } else if let roomsInfo = info {
                                var rooms = [Room]()
                                for dict in roomsInfo {
                                    let id = dict["roomID"] as? Int
                                    let name = dict["name"] as? String
                                    guard let roomID = id else {
                                        let message = NotificationMessage()
                                        message.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                        })
                                        return
                                    }
                                    guard let roomName = name else {
                                        let message = NotificationMessage()
                                        message.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                        })
                                        return
                                    }
                                    let room =  Room(id: StringsMechanisms.generateID(), roomID: roomID, phaseID: phaseID, name: roomName)
                                    rooms.append(room)
                                }
                                let comparison = self.compareRooms(rooms, localRooms: localRooms)
                                let wasChanged = comparison["wasChanged"]
                                let wasDeleted = comparison["wasDeleted"]
                                let newRooms = comparison["newRooms"]
                                if newRooms!.count > 0 {
                                    RoomDAO.createRooms(newRooms!, completionHandler: { (write) in
                                        do {
                                            try write()
                                            let message = NotificationMessage()
                                            message.setDataToInsert(newRooms!)
                                            dispatch_async(dispatch_get_main_queue(), {
                                                NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: nil, info: message)
                                            })
                                        } catch {
                                            //TODO: handle couldNotCreateRealm
                                        }
                                    })
                                }
                            }
                                //unexpected case
                            else {
                                let message = NotificationMessage()
                                message.setServerError(ServerError.UnexpectedCase)
                                dispatch_async(dispatch_get_main_queue(), {
                                    NinoNotificationManager.sharedInstance.addRoomsWereUpdatedFromServerNotification(self, error: message, info: nil)
                                })
                            }
                        })
                    } catch {
                        //TODO: get ID for phase error
                    }
                })
            } catch {
                //TODO: get rooms locally error
            }
        }
    }
    
    static func getIdForRoom(room: String, completionHandler: (id: () throws -> Int) -> Void) {
        RoomDAO.getIdForRoom(room) { (get) in
            do {
                let id = try get()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(id: { () -> Int in
                        return id
                    })
                })
            } catch let error {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(id: { () -> Int in
                        throw error
                    })
                })
            }
        }
    }
    
    static func getRoomWithID(room: String, completionHandler: (getRoom: () throws -> Room) -> Void) {
        RoomDAO.getRoomWithID(room) { (getRoom) in
            do {
                let roomVO = try getRoom()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getRoom: { () -> Room in
                        return roomVO
                    })
                })
            } catch {
                //TODO: could not create realm or not found error
            }
        }
    }
    
    static func getAgendaIDForRoom(roomID: String, completionHandler: (getAgenda: () throws -> Int) -> Void) {
        
    }
    
    private static func compareRooms(serverRooms: [Room], localRooms: [Room]) -> [String: [Room]] {
        var result = [String: [Room]]()
        var wasChanged = [Room]()
        var newRooms = [Room]()
        var wasDeleted = [Room]()
        //check all room phases
        for serverRoom in serverRooms {
            var found = false
            //look for its similar
            for localRoom in localRooms {
                //found
                if serverRoom.roomID == localRoom.roomID {
                    found = true
                    //updated
                    if serverRoom.name != localRoom.name {
                        wasChanged.append(serverRoom)
                    }
                    break
                }
            }
            //not found locally
            if !found {
                newRooms.append(serverRoom)
            }
        }
        for localRoom in localRooms {
            var found = false
            for serverRoom in serverRooms {
                if localRoom.phaseID == serverRoom.phaseID {
                    found = true
                    break
                }
            }
            if !found {
                wasDeleted.append(localRoom)
            }
        }
        
        result["newRooms"] = newRooms
        result["wasChanged"] = wasChanged
        result["wasDeleted"] = wasDeleted
        return result
    }
}
