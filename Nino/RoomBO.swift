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
    static func createRoom(token: String, phaseID: String, name: String, completionHandler: (room: () throws -> Room) -> Void) {
        do {
            let phase = try PhaseBO.getIdForPhase(phaseID)
            RoomMechanism.createRoom(token, classID: phase, roomName: name) { (roomID, error, data) in
                if let error = error {
                    //TODO: handle error data
                    completionHandler(room: { () -> Room in
                        throw ErrorBO.decodeServerError(error)
                    })
                } else if let roomID = roomID {
                    completionHandler(room: { () -> Room in
                        return Room(id: StringsMechanisms.generateID(), roomID: roomID, phaseID: phaseID, name: name)
                    })
                } else {
                    completionHandler(room: { () -> Room in
                        throw ServerError.UnexpectedCase
                    })
                }
            }
        } catch {
            //phase not found error
        }
    }
    
    static func getAllRooms(completionHandler: (rooms: () throws -> [Room]) -> Void) {
        RoomDAO.sharedInstance.getAllRooms { (rooms) in
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
                                    do {
                                        let localPhaseID = try PhaseBO.getLocalIdForPhase(phase)
                                        let room = Room(id: StringsMechanisms.generateID(), roomID: roomID, phaseID: localPhaseID, name: roomName)
                                        serverRooms.append(room)
                                    } catch {
                                        //TODO: phase not found error
                                    }
                                } // end loop
                                let comparison = self.compareRooms(serverRooms, localRooms: localRooms)
                                let wasChanged = comparison["wasChanged"]
                                let wasDeleted = comparison["wasDeleted"]
                                let newRooms = comparison["newRooms"]
                                if newRooms!.count > 0 {
                                    RoomDAO.sharedInstance.createRooms(newRooms!, completionHandler: { (write) in
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
    
    static func getRooms(token: String, phaseID: String, completionHandler: (rooms: () throws -> [Room]) -> Void) {
        
        do {
            let phase = try PhaseBO.getIdForPhase(phaseID)
            RoomMechanism.getRooms(token, classID: phase) { (info, error, data) in
                if let errorType = error {
                    //TODO: Handle error data and code
                    completionHandler(rooms: { () -> [Room] in
                        throw ErrorBO.decodeServerError(errorType)
                    })
                } else if let roomsInfo = info {
                    var rooms = [Room]()
                    for dict in roomsInfo {
                        let id = dict["roomID"] as? Int
                        let name = dict["name"] as? String
                        guard let roomID = id else {
                            completionHandler(rooms: { () -> [Room] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        guard let roomName = name else {
                            completionHandler(rooms: { () -> [Room] in
                                throw ServerError.UnexpectedCase
                            })
                            return
                        }
                        let room =  Room(id: StringsMechanisms.generateID(), roomID: roomID, phaseID: phaseID, name: roomName)
                        rooms.append(room)
                    }
                    completionHandler(rooms: { () -> [Room] in
                        return rooms
                    })
                }
                    //unexpected case
                else {
                    completionHandler(rooms: { () -> [Room] in
                        throw ServerError.UnexpectedCase
                    })
                }
            }
        } catch {
            //TODO: phase not found
        }
    }
    
    static func addRoomsInPhase(rooms: [Room], phase: String) throws {
        //TODO: call DAO or throw phase not found
    }
    
    static func getIdForRoom(room: String) throws -> Int {
        //TODO: call DAO and look for schoolID
        return 1
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
