//
//  DraftMechanism.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 8/24/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class DraftMechanism: NSObject {
    
    static func createDraft(token: String, schoolID: Int, message: String, type: Int, profiles: [Int], metadata: NSDictionary?, attachment: String?, completionHandler: (postID: Int?, postDate: NSDate?, error: Int?, data: String?) -> Void) {
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
                    completionHandler(postID: nil, postDate: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(postID: nil, postDate: nil, error: error, data: data)
                }
                    //success
                else {
                    //FIXME: decode json to get id
                    let id = json["data"]["draft"]["id"].int
                    let dateString = json["data"]["draft"]["createdat"].string
                    let date = StringsMechanisms.dateFromString(dateString!)
                    completionHandler(postID: id, postDate: date, error: nil, data: nil)
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
                        let metadata = subjson["metadata"].string
                        let attachment = subjson["attachment"].string
                        let type = subjson["type"].int
                        let dateString = subjson["createdat"].string
                        let date = StringsMechanisms.dateFromString(dateString!)
                        var dictMetadata: NSDictionary?
                        if let meta = metadata {
                            dictMetadata = StringsMechanisms.convertStringToDictionary(meta)
                        }
                        let dict: [String: AnyObject?] = ["draftID": id, "message": message, "metadata": dictMetadata, "attachment": attachment, "type": type, "date": date]
                        draftsDict.append(dict)
                    }
                    completionHandler(info: draftsDict, error: nil, data: nil)
                }
            })
        } catch {
            //never SHOULD be reached
        }
    }
    
    static func updateDraft(token: String, draftID: Int, schoolID: Int, message: String?, profiles: [Int]?, metadata: NSDictionary?, attachment: NSData?, completionHandler: (updated: Bool?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.UpdateDraft.description([String(draftID)])
            var body: [String: AnyObject] = ["token": token, "school": schoolID]
            if let meta = metadata {
                body["metadata"] = meta
            }
            if let attc = attachment {
                body["attachment"] = attc
            }
            if let txt = message {
                body["message"] = txt
            }
            if let students = profiles {
                body["profiles"] = students
            }
            RestApiManager.makeHTTPPutRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(updated: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(updated: nil, error: error, data: data)
                }
                //success
                else {
                    //FIXME: decode json to get id
                    completionHandler(updated: true, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
    
    static func changeDraftToPost(token: String, schoolID: Int, draftID: Int, completionHandler: (postID: Int?, error: Int?, data: String?) -> Void) {

        do {
            let route = try ServerRoutes.DraftToPost.description([String(draftID)])
            let body: [String: AnyObject] = ["token": token, "school": schoolID]
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(postID: nil, error: error, data: data)
                }
                    //success
                else {
                    let id = json["data"]["post"]["id"].int
                    completionHandler(postID: id, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
    
}
