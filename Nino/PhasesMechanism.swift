//
//  PhasesMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 18/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class PhasesMechanism: NSObject {

    static func getPhases(token: String, schoolID: Int, completionHandler: (info: [[String: AnyObject?]]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetPhases.description([String(schoolID)])
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
                    var phasesDict = [[String: AnyObject?]]()
                    for subjson in datajson {
                        let id = subjson["id"].int
                        let name = subjson["name"].string
                        let menu = subjson["menu"].int
                        let dict: [String: AnyObject?] = ["id": id, "name": name, "menu": menu]
                        phasesDict.append(dict)
                    }
                    completionHandler(info: phasesDict, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle route error
        }
    }
    
    static func createPhase(token: String, schoolID: Int, name: String, completionHandler: (id: Int?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CreatePhase.description([String(schoolID)])
            let body: [String: AnyObject] = ["token": token, "class_name": name]
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(id: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(id: nil, error: error, data: data)
                }
                    //success
                else {
                    let id = json["data"]["class"]["id"].int
                    completionHandler(id: id, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle route error
        }
    }
    
}
