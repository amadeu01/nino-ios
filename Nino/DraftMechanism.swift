//
//  DraftMechanism.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 8/24/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class DraftMechanism: NSObject {
    
    static func createDraft(token: String, schoolID: Int, message: String, type: Int, profiles: [Int], metadata: NSDictionary?, attachment: String?, completionHandler: (postID: Int?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CreateDraft.description(nil)
            var body: [String: AnyObject] = ["token": token, "message": message, "type": type, "profiles": profiles, "school": schoolID]
            if let meta = metadata {
                body["metadata"] = meta
            }
            if let attc = attachment {
                body["attachment"] = attc
            }
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(postID: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(postID: nil, error: error, data: data)
                }
                    //success
                else {
                    //FIXME: decode json to get id
                    let id = json["data"]["draft"]["id"].int
                    completionHandler(postID: id, error: nil, data: nil)
                }
            })
        } catch {
            //never will be reached
        }
    }
    
    static func getDrafts(token: String, schoolID: Int, studentID: Int, completionHandler: (info: [[String: AnyObject?]]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetStudentDraftsForSchool.description([String(schoolID), String(studentID)])
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
                    var draftsDict = [[String: AnyObject?]]()
                    for subjson in datajson {
                        let id = subjson["id"].int
                        let message = subjson["message"].string
                        let metadata = subjson["metadata"].object
                        let attachment = subjson["attachment"].string
                        let type = subjson["type"].int
                        let dict: [String: AnyObject?] = ["draftID": id, "message": message, "metadata": metadata, "attachment": attachment, "type": type]
                        draftsDict.append(dict)
                    }
                    completionHandler(info: draftsDict, error: nil, data: nil)
                }
            })
        } catch {
            //never SHOULD be reached
        }
    }
}
