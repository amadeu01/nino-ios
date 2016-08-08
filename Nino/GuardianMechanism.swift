//
//  GuardianMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 05/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class GuardianMechanism: NSObject {

    static func createGuardian(token: String, schoolID: Int, studentID: Int, email: String, name: String, surname: String, completionHandler: (profileID: Int?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CreateGuardian.description(nil)
            let body: [String: AnyObject] = ["token": token, "school_id": schoolID, "student_profile_id": studentID, "name": name, "surname": surname, "email": email]
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
        } catch {
            //never will be reached
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
        } catch {
            //TODO: handle missing parameter error
        }
    }
    
}
