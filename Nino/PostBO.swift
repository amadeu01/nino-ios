//
//  PostBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of post
class PostBO: NSObject {

    static func createPost(type: Int, message: String, targets: [String], metadata: NSDictionary?, attachment: NSData?, completionHandler: (create: () throws -> Post) -> Void) -> Void {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(create: { () -> Post in
                throw AccountError.InvalidToken
            })
            return
        }
        var profiles = [Int]()
        for target in targets {
            StudentBO.getIdForStudent(target, completionHandler: { (id) in
                do {
                    let userID = try id()
                    profiles.append(userID)
                } catch let error {
                    dispatch_async(dispatch_get_main_queue(), { 
                        completionHandler(create: { () -> Post in
                            throw error
                        })
                    })
                    return
                }
            })
        }
        
        let post = Post(id: StringsMechanisms.generateID(), postID: nil, type: type, date: nil, message: message, attachment: attachment, targets: targets, readProfileIDs: nil, metadata: metadata)
        PostDAO.sharedInstance.createPost(post) { (write) in
            do {
                try write()
                //FIXME: fix attachment
                PostMechanism.createPost(token, message: message, type: type, profiles: profiles, metadata: metadata, attachment: nil, completionHandler: { (postID, error, data) in
                    if let err = error {
                        //handle error data
                        dispatch_async(dispatch_get_main_queue(), { 
                            completionHandler(create: { () -> Post in
                                throw ErrorBO.decodeServerError(err)
                            })
                        })
                    } else if let postServerID = postID {
                        PostDAO.sharedInstance.upatePostID(post.id, serverID: postServerID, completionHandler: { (update) in
                            do {
                                try update()
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(create: { () -> Post in
                                        return Post(id: post.id, postID: postServerID, type: post.type, date: post.date, message: post.message, attachment: post.attachment, targets: post.targets, readProfileIDs: post.readProfileIDs, metadata: post.metadata)
                                    })
                                })
                            } catch let error {
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(create: { () -> Post in
                                        throw error
                                    })
                                })
                            }
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { 
                            completionHandler(create: { () -> Post in
                                throw ServerError.UnexpectedCase
                            })
                        })
                    }
                })
            } catch let error {
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(create: { () -> Post in
                        throw error
                    })
                })
            }
        }
    }
}
