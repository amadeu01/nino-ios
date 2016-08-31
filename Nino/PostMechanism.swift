//
//  PostMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 22/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class PostMechanism: NSObject {
    
    static func createPost(token: String, message: String, type: Int, profiles: [Int], metadata: NSDictionary?, attachment: String?, completionHandler: (postID: Int?, error: Int?, data: String?) -> Void) {
        do {
            let route = try ServerRoutes.CreatePost.description(nil)
            var body: [String: AnyObject] = ["token": token, "message": message, "type": type, "profiles": profiles]
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
                    let id = json["data"]["post"]["id"].int
                    completionHandler(postID: id, error: nil, data: nil)
                }
            })
        } catch {
            //never will be reached
        }
    }
}
