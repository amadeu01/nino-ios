//
//  GuardianMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 05/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class GuardianMechanism: NSObject {

    static func createGuardian(token: String, schoolID: Int, studentID: Int, email: String, completionHandler: (profileID: Int?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CreateGuardian.description(nil)
            let body: [String: AnyObject] = ["token": token, "school_id": schoolID, "student_profile_id": studentID, "email": email]
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(profileID: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(profileID: nil, error: error, data: data)
                }
                    //success
                else {
                    //FIXME: decode json to get id
                    let id = json["data"]["profile"]["id"].int
                    completionHandler(profileID: id, error: nil, data: nil)
                }
            })
        } catch let error {
            //never will be reached
            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
        }
    }
    
    static func getGuardians(token: String, studentID: Int, completionHandler: (info: [[String: AnyObject?]]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetGuardians.description([String(studentID)])
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
                    var guardiansDict = [[String: AnyObject?]]()
                    for subjson in datajson {
                        let id = subjson["id"].int
                        let name = subjson["name"].string
                        let surname = subjson["surname"].string
                        let gender = subjson["gender"].int
                        let email = subjson["email"].string
                        let jsonBirthdate = subjson["birthdate"].string
                        var optionalBirthdate: NSDate?
                        if let birthdate = jsonBirthdate {
                            optionalBirthdate = StringsMechanisms.dateFromString(birthdate)
                        }
                        let dict: [String: AnyObject?] = ["id": id, "name": name, "surname": surname, "gender": gender, "birthdate": optionalBirthdate, "email": email]
                        guardiansDict.append(dict)
                    }
                    completionHandler(info: guardiansDict, error: nil, data: nil)
                }
            })
        } catch let error {
            //TODO: handle missing parameter error
            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
        }
    }
    
    static func updateNameAndSurname(token: String, name: String, surname: String, completionHandler: (info: [String: AnyObject?]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.UpdateMyProfile.description(nil)
            let body: [String: AnyObject] = ["token": token, "name": name, "surname": surname]
            RestApiManager.makeHTTPPutRequest(route, body: body, onCompletion: {(json, error, statusCode) in
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
                else {
                    let data = json["data"]
                    
                    let id = data["id"].int
                    let dict: [String: AnyObject?] = ["id": id]
                    
                    completionHandler(info: dict, error: nil, data: nil)
                }
            })
        } catch let error {
            //TODO Handle error
            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
        }
    }
    
    static func getStudents(token: String, completionHandler: (info: [[String: AnyObject?]]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetStudentsForGuardian.description(nil)
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
                    if let error = json["error"].int {
                        completionHandler(info: nil, error: error, data: nil)
                        return
                    }
                    guard let datajson = data else {
                        completionHandler(info: nil, error: nil, data: nil)
                        return
                    }
                    var guardiansDict = [[String: AnyObject?]]()
                    for subjson in datajson {
                        let id = subjson["id"].int
                        let name = subjson["name"].string
                        let surname = subjson["surname"].string
                        let gender = subjson["gender"].int
                        let school = subjson["school"].int
                        let room = subjson["room"].int
                        let jsonBirthdate = subjson["birthdate"].string
                        let created = subjson["createdat"].string
                        var optionalBirthdate: NSDate?
                        if let birthdate = jsonBirthdate {
                            optionalBirthdate = StringsMechanisms.dateFromString(birthdate)
                        }
                        var createdAt: NSDate?
                        if let date = created {
                            createdAt = StringsMechanisms.dateFromString(date)
                        }
                        let dict: [String: AnyObject?] = ["id": id, "name": name, "surname": surname, "gender": gender, "birthdate": optionalBirthdate, "school": school, "room": room, "createdAt": createdAt]
                        guardiansDict.append(dict)
                    }
                    completionHandler(info: guardiansDict, error: nil, data: nil)
                }
            })
        } catch let error {
            //TODO: handle missing parameter error
            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
        }
    }
    
}
