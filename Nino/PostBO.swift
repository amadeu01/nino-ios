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
        PostDAO.createPost([post]) { (write) in
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
            } catch let error {
                //TODO: handle error
                print("get id for post DAO error")
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    static func getPostsForStudent(student: String, completionHandler: (getPosts: () throws -> [Post]) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(getPosts: { () -> [Post] in
                throw AccountError.InvalidToken
            })
            return
        }
        PostDAO.getPostsForStudent(student) { (getPosts) in
            do {
                let localPosts = try getPosts()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(getPosts: { () -> [Post] in
                        return localPosts
                    })
                })
                StudentBO.getIdForStudent(student, completionHandler: { (id) in
                    do {
                        let id = try id()
                        PostMechanism.getPosts(token, studentID: id, completionHandler: { (info, error, data) in
                            if let err = error {
                                let error = NotificationMessage()
                                error.setServerError(ErrorBO.decodeServerError(err))
                                dispatch_async(dispatch_get_main_queue(), {
                                    NinoNotificationManager.sharedInstance.addPostsUpdatedNotification(self, error: error, info: nil)
                                })
                            }
                            else if let array = info {
                                var serverPosts = [Post]()
                                for dict in array {
                                    guard let postID = dict["postID"] as? Int else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addPostsUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    guard let type = dict["type"] as? Int else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addPostsUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    guard let message = dict["message"] as? String else {
                                        let error = NotificationMessage()
                                        error.setServerError(ServerError.UnexpectedCase)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addPostsUpdatedNotification(self, error: error, info: nil)
                                        })
                                        return
                                    }
                                    let metadata = dict["metadata"] as? NSDictionary
                                    let attachment = dict["attachment"] as? String
                                    let date = dict["date"] as? NSDate
                                    var dictionary: NSDictionary?
                                    let post = Post(id: StringsMechanisms.generateID(), postID: postID, type: type, date: date, message: message, attachment: nil, targets: [student], readProfileIDs: nil, metadata: metadata)
                                    serverPosts.append(post)
                                }
                                let comparison = PostBO.comparePosts(serverPosts, localPosts: localPosts)
                                let wasChanged = comparison["wasChanged"]
                                let wasDeleted = comparison["wasDeleted"]
                                let newPosts = comparison["newPosts"]
                                if newPosts!.count > 0 {
                                    PostDAO.createPost(newPosts!, completionHandler: { (write) in
                                            do {
                                                try write()
                                                let message = NotificationMessage()
                                                message.setDataToInsert(newPosts!)
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    NinoNotificationManager.sharedInstance.addPostsUpdatedNotification(self, error: nil, info: message)
                                                })
                                            } catch let error {
                                                //TODO: handle error
                                                print("create local draft error")
                                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                            }
                                        })
                                }
                                //TODO: posts was deleted
                                //TODO: posts was updated
                            }
                                //unexpected case
                            else {
                                let error = NotificationMessage()
                                error.setServerError(ServerError.UnexpectedCase)
                                dispatch_async(dispatch_get_main_queue(), {
                                    NinoNotificationManager.sharedInstance.addPostsUpdatedNotification(self, error: error, info: nil)
                                })
                            }
                        })
                    } catch let error {
                        //TODO Handle error
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                })
            } catch let error {
                //TODO Handle error
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
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
                    }//TODO: must else if here, of else can add the same post multiple times
                    if serverPost.attachment != localPost.attachment {
                        wasChanged.append(serverPost)
                        continue
                    }//TODO: must else if here, of else can add the same post multiple times
                    if serverPost.metadata != localPost.metadata {
                        wasChanged.append(serverPost)
                        continue
                    }//TODO: must else if here, of else can add the same post multiple times
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
    
    //swiftlint:disable function_body_length
    static func getPostsTypeForDate(student: String, type: Int, date: NSDate, completionHandler: (getPosts: () throws -> [Post]) -> Void) {
        var localPosts: [Post]?
        var serverPosts: [Post]?
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(getPosts: { () -> [Post] in
                throw AccountError.InvalidToken
            })
            return
        }
        dispatch_group_enter(NinoDispatchGroupes.getGroup(1))
        PostDAO.getPostsTypeForDate(student, type: type, date: date) { (getPosts) in
            do {
                localPosts = try getPosts()
                dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
            } catch {
                //TODO: handle error
                print("get posts type date local error")
                dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
            }
        }
        dispatch_group_enter(NinoDispatchGroupes.getGroup(1))
        StudentBO.getIdForStudent(student) { (id) in
            do {
                let studentID = try id()
                SchoolBO.getIdForSchool({ (id) in
                    do {
                        let schoolID = try id()
                        //FIXME: fix offset
                        PostMechanism.getPosts(type, offset: nil, token: token, schoolID: schoolID, studentID: studentID, completionHandler: { (info, error, data) in
                            if let err = error {
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(getPosts: { () -> [Post] in
                                        throw ErrorBO.decodeServerError(err)
                                    })
                                })
                                dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
                            } else if let array = info {
                                for dict in array {
                                    if serverPosts == nil {
                                        serverPosts = [Post]()
                                    }
                                    guard let postID = dict["postID"] as? Int else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(getPosts: { () -> [Post] in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                        serverPosts = nil
                                        dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
                                        return
                                    }
                                    guard let postType = dict["type"] as? Int else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(getPosts: { () -> [Post] in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                        serverPosts = nil
                                        dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
                                        return
                                    }
                                    guard let message = dict["message"] as? String else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(getPosts: { () -> [Post] in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                        serverPosts = nil
                                        dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
                                        return
                                    }
                                    let metadata = dict["metadata"] as? NSDictionary
                                    let attachment = dict["attachment"] as? String
                                    let postDate = dict["date"] as? NSDate
//                                    if type != postType {
//                                        //if it don't exists locally, save it
//                                        continue
//                                    }
                                    if let internalDate = postDate {
                                        //if it don't exists locally, save it
                                        if !NSCalendar.currentCalendar().isDate(internalDate, inSameDayAsDate: date) {
                                            continue
                                        }
                                    } else {
                                        continue
                                    }
                                    let post = Post(id: StringsMechanisms.generateID(), postID: postID, type: postType, date: postDate, message: message, attachment: nil, targets: [student], readProfileIDs: nil, metadata: metadata)
                                    serverPosts!.append(post)
                                }
                                dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
                            } else {
                                //student don't have post
                                dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
                            }
                        })
                    } catch {
                        //TODO: handle error
                        print("get school id error")
                    }
                })
            } catch {
                //TODO: handle error
                print("get id student error")
                dispatch_group_leave(NinoDispatchGroupes.getGroup(1))
            }
        }
        dispatch_group_notify(NinoDispatchGroupes.getGroup(1), dispatch_get_main_queue()) { 
            if let serverArray = serverPosts {
                if let localArray = localPosts {
                    let comparison = self.comparePosts(serverArray, localPosts: localArray)
                    let newPosts = comparison["newPosts"]
                    let updated = comparison["wasChanged"]
                    let deleted = comparison["wasDeleted"]
                    //update updated posts
                    //delete deleted posts
                    PostDAO.createPost(newPosts!, completionHandler: { (write) in
                        do {
                            try write()
                            dispatch_async(dispatch_get_main_queue(), { 
                                let array = localArray + newPosts!
                                completionHandler(getPosts: { () -> [Post] in
                                    return array
                                })
                            })
                        } catch {
                            //TODO: handle error
                            print("create local post error")
                        }
                    })
                } else {
                    PostDAO.createPost(serverArray, completionHandler: { (write) in
                        do {
                            try write()
                            dispatch_async(dispatch_get_main_queue(), { 
                                completionHandler(getPosts: { () -> [Post] in
                                    return serverArray
                                })
                            })
                        } catch {
                            //TODO: handle error
                            print("create local post error")
                        }
                    })
                }
            } else {
                if let localArray = localPosts {
                    if localArray.count > 0 {
                        //delete posts
                        print("should delete post")
                    } else {
                        completionHandler(getPosts: { () -> [Post] in
                            return [Post]()
                        })
                    }
                } else {
                    //TODO: handle error
                    print("get local posts error")
                }
            }
        }
    }
}
