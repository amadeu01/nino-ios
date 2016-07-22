//
//  RoomMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 19/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class RoomMechanism: NSObject {

    /**
     Gets all rooms for phase
     
     - parameter token:             access token
     - parameter classID:           phase id
     - parameter completionHandler: completion handler with optional: array of dictionaries - roomID?, name? -, error and error data
     */
    static func getRooms(token: String, classID: Int, completionHandler: (info: [[String: AnyObject?]]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetRooms.description([String(classID)])
            RestApiManager.makeHTTPGetRequest(nil, path: route, token: token, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(info: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(info: nil, error: error, data: data)
                }
                //success
                else {
                    let data = json["data"].array
                    guard let datajson = data else {
                        completionHandler(info: nil, error: nil, data: nil)
                        return
                    }
                    var roomsDict = [[String: AnyObject?]]()
                    for subjson in datajson {
                        let id = subjson["id"].int
                        let name = subjson["name"].string
                        let dict: [String: AnyObject?] = ["roomID": id, "name": name]
                        roomsDict.append(dict)
                    }
                    completionHandler(info: roomsDict, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: missing parameter error
        }
    }
    
    /**
     Creates a new room
     
     - parameter token:             access token
     - parameter classID:           phase id
     - parameter roomName:          room name
     - parameter completionHandler: completion handler with optional: roomID, error, error data
     */
    static func createRoom(token: String, classID: Int, roomName: String, completionHandler: (roomID: Int?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CreateRoom.description([String(classID)])
            let body = ["token": token, "room_name": roomName]
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(roomID: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(roomID: nil, error: error, data: data)
                }
                    //success
                else {
                    //FIXME: decode json to get id
                    let id = json["data"]["room"]["id"].int
                    completionHandler(roomID: id, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: missing parameter error
        }
    }
    
}
