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
                        return Room(roomID: roomID, phaseID: phase, name: name)
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
                        let room =  Room(roomID: roomID, phaseID: phase, name: roomName)
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
}
