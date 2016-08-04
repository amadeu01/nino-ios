//
//  SchoolMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 11/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Mechanism designed to handle all school operation
class SchoolMechanism: NSObject {

    /**
     Tries to create an school
     
     - parameter token:      access token
     - parameter name:       school's name
     - parameter address:    school's address
     - parameter telephone:  school's phone
     - parameter email:      school's main email
     - parameter logo:       optional school's logo
     - parameter completionHandler: completionHandler with optional schoolID, optional error and optional extra information about the error
     */
    static func createSchool(token: String, name: String, address: String, telephone: String, email: String, logo: NSData?, completionHandler: (schoolID: Int?, error: Int?, data: String?) -> Void) {
        //FIXME: send logo
        let body: [String: AnyObject] = ["token": token, "name": name, "email": email, "telephone": telephone, "addr": address]
        do {
            let route = try ServerRoutes.CreateSchool.description(nil)
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(schoolID: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(schoolID: nil, error: error, data: data)
                }
                    //success
                else {
                    let schoolID = json["data"]["school"]["id"].int
                    completionHandler(schoolID: schoolID, error: nil, data: nil)
                }
            })
        } catch {
            //never will be reached
        }
    }
    
    /**
     Send profile image
     
     - parameter token:             access token
     - parameter imageData:         NSData of the image
     - parameter schoolID:          school id
     - parameter completionHandler: completion handler with optional: success, error and error data
     */
    static func sendProfileImage(token: String, imageData: NSData, schoolID: Int, completionHandler: (success: Bool?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.SendSchoolLogo.description([String(schoolID)])
            RestApiManager.makeHTTPPostUploadRequest(route, token: token, data: imageData, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(success: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(success: false, error: error, data: data)
                }
                //success
                else {
                    completionHandler(success: true, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
    
    /**
     Gets information about the school
     
     - parameter token:             access token
     - parameter schoolID:          school id
     - parameter completionHandler: completion handler
     */
    static func getSchool(token: String, completionHandler: (info: [[String: AnyObject?]]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetSchool.description(nil)
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
                    var schoolsDict = [[String: AnyObject?]]()
                    for subjson in datajson {
                        let id = subjson["id"].int
                        let name = subjson["name"].string
                        let email = subjson["email"].string
                        let telephone = subjson["telephone"].string
                        let address = subjson["address"].string
                        let dict: [String: AnyObject?] = ["id": id, "name": name, "email": email, "telephone": telephone, "address": address]
                        schoolsDict.append(dict)
                    }
                    completionHandler(info: schoolsDict, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: never will be reached
        }
    }
}
