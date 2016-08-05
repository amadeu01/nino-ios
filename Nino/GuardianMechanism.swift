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
            
        } catch {
            //TODO: handle missing parameter error
        }
    }
    
}
