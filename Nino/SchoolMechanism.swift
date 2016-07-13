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
     
     - parameter token:
     - parameter name:       school's name
     - parameter address:    school's address
     - parameter telephone:  school's phone
     - parameter email:      school's main email
     - parameter logo:       optional school's logo
     - parameter completionHandler: completionHandler with optional userID, optional error and optional extra information about the error
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
}
