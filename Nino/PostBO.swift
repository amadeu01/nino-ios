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
        PostDAO.createPost(post) { (write) in
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
                        PostDAO.upatePostID(post.id, serverID: postServerID, completionHandler: { (update) in
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
    
    static func getIdForPost(post: String, completionHandler: (id: () throws -> Int) -> Void) {
        PostDAO.getIdForPost(post) { (id) in
            do {
                let postID = try id()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(id: { () -> Int in
                        return postID
                    })
                })
            } catch {
                //TODO: handle error
                print("get id for post DAO error")
            }
        }
    }
    
    static func getPostsForStudent(id: String, completionHandler: (posts: () throws -> [Post]) -> Void) {
        
    }
    
    static func comparePosts(serverPosts: [Post], localPosts: [Post]) -> [String: [Post]] {
        var result = [String: [Post]]()
        var wasChanged = [Post]()
        var newPosts = [Post]()
        var wasDeleted = [Post]()
        //check all server phases
        for serverPost in serverPosts {
            var found = false
            //look for its similar
            for localPost in localPosts {
                //found
                if serverPost.postID == localPost.postID {
                    found = true
                    //updated
                    if serverPost.message != localPost.message {
                        wasChanged.append(serverPost)
                        continue
                    }
                    if serverPost.attachment != localPost.attachment {
                        wasChanged.append(serverPost)
                        continue
                    }
                    if serverPost.metadata != localPost.metadata {
                        wasChanged.append(serverPost)
                        continue
                    }
                    if serverPost.targets != localPost.targets {
                        wasChanged.append(serverPost)
                        continue
                    }
                    if let serverRead = serverPost.readProfileIDs {
                        if let localRead = localPost.readProfileIDs {
                            if serverRead != localRead {
                                wasChanged.append(serverPost)
                                continue
                            }
                        } else {
                            wasChanged.append(serverPost)
                            continue
                        }
                    }
                    if let serverDate = serverPost.date {
                        if let localDate = localPost.date {
                            if !NSCalendar.currentCalendar().isDate(serverDate, inSameDayAsDate: localDate) {
                                wasChanged.append(serverPost)
                                continue
                            }
                        } else {
                            wasChanged.append(serverPost)
                            continue
                        }
                    }
                }
            }
            //not found locally
            if !found {
                newPosts.append(serverPost)
            }
        }
        for localPost in localPosts {
            var found = false
            for serverPost in serverPosts {
                if localPost.postID == serverPost.postID {
                    found = true
                    break
                }
            }
            if !found {
                wasDeleted.append(localPost)
            }
        }
        
        result["newPosts"] = newPosts
        result["wasChanged"] = wasChanged
        result["wasDeleted"] = wasDeleted
        return result
    }
}
