//
//  StudentMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 19/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class StudentMechanism: NSObject {

    /**
     Gets students for room
     
     - parameter token:             access token
     - parameter roomID:            room id
     - parameter completionHandler: completion handler with optional: array of dictionaries - profileID?, name?, surname?, birthdate?, gender? -, error and error data
     */
    static func getStudents(token: String, roomID: Int, completionHandler: (info: [[String: AnyObject?]]?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.GetStudents.description([String(roomID)])
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
                    var studentsDict = [[String: AnyObject?]]()
                    for subjson in datajson {
                        let id = subjson["id"].int
                        let name = subjson["name"].string
                        let surname = subjson["surname"].string
                        //TODO: Unwrap this
                        let birthDate = subjson["birthdate"].string
                        let gender = subjson["gender"].int
                        let createdAt = subjson["createdat"].string
                        let dict: [String: AnyObject?] = ["profileID": id, "name": name, "surname": surname, "birthdate": StringsMechanisms.dateFromString(birthDate!), "gender": gender, "createdAt": StringsMechanisms.dateFromString(createdAt!)]
                        studentsDict.append(dict)
                    }
                    completionHandler(info: studentsDict, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter
        }
    }
    
    /**
     Creates new student
     
     - parameter token:             access token
     - parameter schoolID:          school id
     - parameter roomID:            room id
     - parameter name:              student name
     - parameter surname:           student surname
     - parameter birthDate:         student birthdate
     - parameter gender:            student gender.raw
     - parameter completionHandler: completion handler with optional: profileID, error and error data
     */
    static func createStudent(token: String, schoolID: Int, roomID: Int, name: String, surname: String, birthDate: NSDate, gender: Int, completionHandler: (profileID: Int?, createdAt: NSDate?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CreateStudent.description([String(schoolID)])
            let date = StringsMechanisms.convertDate(birthDate)
            let body: [String: AnyObject] = ["token": token, "room_id": roomID, "name": name, "surname": surname, "birthdate": date, "gender": gender]
            RestApiManager.makeHTTPPostRequest(route, body: body, onCompletion: { (json, error, statusCode) in
                guard let statusCode = statusCode else {
                    completionHandler(profileID: nil, createdAt: nil, error: error?.code, data: nil)
                    return
                }
                //error
                if statusCode != 200 {
                    //FIXME: decode data as json
                    let data = json["data"].string
                    let error = json["error"].int
                    completionHandler(profileID: nil, createdAt: nil, error: error, data: data)
                }
                    //success
                else {
                    //FIXME: decode json to get id
                    let id = json["data"]["profile"]["id"].int
                    let createdAt = json["data"]["profile"]["createdat"].string
                    var createdDate: NSDate?
                    if let date = createdAt {
                        createdDate = StringsMechanisms.dateFromString(date)
                    }
                    completionHandler(profileID: id, createdAt: createdDate, error: nil, data: nil)
                }
            })
        } catch {
            //TODO: handle missing parameter error
        }
    }
}
