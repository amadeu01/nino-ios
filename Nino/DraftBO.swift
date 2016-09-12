//
//  DraftBO.swift
//  Nino
//
//  Created by Danilo Becke on 05/09/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

//swiftlint:disable type_body_length
class DraftBO: NSObject {
    
    static func createDraft(type: Int, message: String, targets: [String], metadata: NSDictionary?, attachment: NSData?, completionHandler: (create: () throws -> Post) -> Void) -> Void {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(create: { () -> Post in
                throw AccountError.InvalidToken
            })
            return
        }
        SchoolBO.getIdForSchool { (id) in
            do {
                let id = try id()
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
                DraftDAO.createDraft(post) { (write) in
                    do {
                        try write()
                        //FIXME: fix attachment
                        DraftMechanism.createDraft(token, schoolID: id, message: message, type: type, profiles: profiles, metadata: metadata, attachment: nil, completionHandler: { (postID, postDate, error, data) in
                            if let err = error {
                                //handle error data
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(create: { () -> Post in
                                        throw ErrorBO.decodeServerError(err)
                                    })
                                })
                            } else if let postServerID = postID {
                                DraftDAO.upateDraftID(post.id, serverID: postServerID, completionHandler: { (update) in
                                    do {
                                        try update()
                                        PostDAO.updatePostDate(post.id, date: postDate!, completionHandler: { (update) in
                                            do {
                                                try update()
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    completionHandler(create: { () -> Post in
                                                        return Post(id: post.id, postID: postServerID, type: post.type, date: postDate!, message: post.message, attachment: post.attachment, targets: post.targets, readProfileIDs: post.readProfileIDs, metadata: post.metadata)
                                                    })
                                                })
                                            } catch let error{
                                                print("update error")
                                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                                //TODO: handle updateDate error
                                            }
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
            } catch let error {
                print("getschoolID error")
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                //TODO: handle getSchoolID error
            }
        }
    }
    
//swiftlint:disable function_body_length
    static func shouldCreateScheduleDraft(student: String, date: NSDate, completionHandler: (shouldCreate: () throws -> Bool) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(shouldCreate: { () -> Bool in
                throw AccountError.InvalidToken
            })
            return
        }
        var schoolID: Int?
        var shouldCreateLocally: Bool?
        var serverDraft: Post?
        var studentID: Int?
        dispatch_group_enter(NinoDispatchGroupes.getGroup(2))
        SchoolBO.getIdForSchool { (id) in
            do {
                schoolID = try id()
                StudentBO.getIdForStudent(student, completionHandler: { (id) in
                    do {
                        studentID = try id()
                        DraftMechanism.getDrafts(token, schoolID: schoolID!, studentID: studentID!, completionHandler: { (info, error, data) in
                            //error
                            if let err = error {
                                //TODO: Handle error data and code
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(shouldCreate: { () -> Bool in
                                        throw ErrorBO.decodeServerError(err)
                                    })
                                })
                                dispatch_group_leave(NinoDispatchGroupes.getGroup(2))
                                return
                            }
                                //success
                            else if let array = info {
                                for dict in array {
                                    guard let draftID = dict["draftID"] as? Int else {
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            completionHandler(shouldCreate: { () -> Bool in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                        serverDraft = nil
                                        dispatch_group_leave(NinoDispatchGroupes.getGroup(2))
                                        return
                                    }
                                    guard let type = dict["type"] as? Int else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(shouldCreate: { () -> Bool in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                        serverDraft = nil
                                        dispatch_group_leave(NinoDispatchGroupes.getGroup(2))
                                        return
                                    }
                                    guard let message = dict["message"] as? String else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(shouldCreate: { () -> Bool in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                        serverDraft = nil
                                        dispatch_group_leave(NinoDispatchGroupes.getGroup(2))
                                        return
                                    }
                                    let metadata = dict["metadata"] as? NSDictionary
                                    let attachment = dict["attachment"] as? String
                                    let optionalDate = dict["date"] as? NSDate
                                    if type != PostTypes.Schedule.rawValue {
                                        continue
                                    }
                                    if let postDate = optionalDate {
                                        if !NSCalendar.currentCalendar().isDate(postDate, inSameDayAsDate: date) {
                                            continue
                                        }
                                    } else {
                                        continue
                                    }
                                    
                                    serverDraft = Post(id: StringsMechanisms.generateID(), postID: draftID, type: type, date: optionalDate, message: message, attachment: nil, targets: [student], readProfileIDs: nil, metadata: metadata)
                                    break
                                }
                                dispatch_group_leave(NinoDispatchGroupes.getGroup(2))
                            }
                            //unexpected case
                            else {
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(shouldCreate: { () -> Bool in
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                                dispatch_group_leave(NinoDispatchGroupes.getGroup(2))
                            }
                        })
                        dispatch_group_enter(NinoDispatchGroupes.getGroup(2))
                        DraftDAO.isThereScheduleForStudentAndDate(student, date: date) { (isThere) in
                            do {
                                shouldCreateLocally = try !isThere()
                                dispatch_group_leave(NinoDispatchGroupes.getGroup(2))
                            } catch {
                                print("not found error")
                                //TODO: handle not found or realm error
                            }
                        }
                    } catch {
                        //TODO: handle error
                        print("get student id error")
                    }
                })
            } catch {
                //TODO: handle error
                print("get school id error")
            }
        }
        dispatch_group_notify(NinoDispatchGroupes.getGroup(2), dispatch_get_main_queue()) { 
            if let shouldCreate = shouldCreateLocally {
                if let draft = serverDraft {
                    if shouldCreate {
                        DraftDAO.createDraft(draft, completionHandler: { (write) in
                            do {
                                try write()
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(shouldCreate: { () -> Bool in
                                        return false
                                    })
                                })
                            } catch {
                                //TODO: handle error
                                print("create draft locally error")
                            }
                        })
                    } else {
                        DraftDAO.getIDForScheduleDraft(student, date: date, completionHandler: { (getID) in
                            do {
                                let scheduleID = try getID()
                                DraftDAO.updateDraft(scheduleID, message: draft.message, targets: draft.targets, metadata: draft.metadata, attachment: draft.attachment, completionHandler: { (update) in
                                    do {
                                        try update()
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            completionHandler(shouldCreate: { () -> Bool in
                                                return false
                                            })
                                        })
                                    } catch {
                                        //TODO: handle error
                                        print("update draft locally error")
                                    }
                                })
                            } catch {
                                //TODO: handle error
                                print("get schedule id error")
                            }
                        })
                    }
                } else {
                    if shouldCreate {
                        completionHandler(shouldCreate: { () -> Bool in
                            return shouldCreate
                        })
                    } else {
                        //TODO: create remote draft
                        guard let school = schoolID else {
                            completionHandler(shouldCreate: { () -> Bool in
                                throw AccountError.InvalidToken
                            })
                            return
                        }
                        DraftDAO.getScheduleDraft(student, date: date, completionHandler: { (getSchedule) in
                            do {
                                let draft = try getSchedule()
                                if let draftSchedule = draft {
                                    guard let stdID = studentID else {
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            completionHandler(shouldCreate: { () -> Bool in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                        return
                                    }
                                    DraftMechanism.createDraft(token, schoolID: school, message: draftSchedule.message, type: draftSchedule.type, profiles: [stdID], metadata: draftSchedule.metadata, attachment: nil, completionHandler: { (postID, postDate, error, data) in
                                        if let err = error {
                                            //TODO: remove locally
                                            dispatch_async(dispatch_get_main_queue(), { 
                                                completionHandler(shouldCreate: { () -> Bool in
                                                    throw ErrorBO.decodeServerError(err)
                                                })
                                            })
                                        } else  if let id = postID {
                                            if let remoteDate = postDate {
                                                DraftDAO.upateDraftID(draftSchedule.id, serverID: id, completionHandler: { (update) in
                                                    do {
                                                        try update()
                                                        PostDAO.updatePostDate(draftSchedule.id, date: remoteDate, completionHandler: { (update) in
                                                            do {
                                                                try update()
                                                                dispatch_async(dispatch_get_main_queue(), { 
                                                                    completionHandler(shouldCreate: { () -> Bool in
                                                                        return false
                                                                    })
                                                                })
                                                            } catch {
                                                                //TODO: handle error
                                                                print("update date error")
                                                            }
                                                        })
                                                    } catch {
                                                        //TODO: handle error
                                                        print("updat draft id error")
                                                    }
                                                })
                                            } else {
                                                //TODO: remove locally
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    completionHandler(shouldCreate: { () -> Bool in
                                                        throw ServerError.UnexpectedCase
                                                    })
                                                })
                                            }
                                        } else {
                                            //TODO: remove locally
                                            dispatch_async(dispatch_get_main_queue(), {
                                                completionHandler(shouldCreate: { () -> Bool in
                                                    throw ServerError.UnexpectedCase
                                                })
                                            })
                                        }
                                    })
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        completionHandler(shouldCreate: { () -> Bool in
                                            throw ServerError.UnexpectedCase
                                        })
                                    })
                                }
                            } catch {
                                //TODO: handle error
                                print("get draft schedule error")
                            }
                        })
                        
                        completionHandler(shouldCreate: { () -> Bool in
                            return false
                        })
                    }
                }
            } else {
                //TODO: handle error
                print("should create locally error")
            }
        }
    }
    
    static func updateDraft(draft: String, message: String?, targets: [String]?, metadata: NSDictionary?, attachment: NSData?, completionHandler: (update: () throws -> Post) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(update: { () -> Post in
                throw AccountError.InvalidToken
            })
            return
        }
        var profiles: [Int]?
        if let students = targets {
            profiles = [Int]()
            for target in students {
                StudentBO.getIdForStudent(target, completionHandler: { (id) in
                    do {
                        let userID = try id()
                        profiles!.append(userID)
                    } catch let error {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(update: { () -> Post in
                                throw error
                            })
                        })
                        return
                    }
                })
            }
        }
        SchoolBO.getIdForSchool { (id) in
            do {
                let schoolID = try id()
                PostBO.getIdForPost(draft, completionHandler: { (id) in
                    do {
                        let draftID = try id()
                        DraftDAO.updateDraft(draft, message: message, targets: targets, metadata: metadata, attachment: attachment) { (update) in
                            do {
                                let newDraft = try update()
                                DraftMechanism.updateDraft(token, draftID: draftID, schoolID: schoolID, message: message, profiles: profiles, metadata: metadata, attachment: attachment, completionHandler: { (updated, error, data) in
                                    //error
                                    if let err = error {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(update: { () -> Post in
                                                throw ErrorBO.decodeServerError(err)
                                            })
                                        })
                                    }
                                        //success
                                    else if updated != nil {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(update: { () -> Post in
                                                return newDraft
                                            })
                                        })
                                    }
                                        //unexpected case
                                    else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(update: { () -> Post in
                                                throw ServerError.UnexpectedCase
                                            })
                                        })
                                    }
                                })
                            } catch let error {
                                print("realmError")
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                //TODO: handle local errors
                            }
                        }
                    } catch let error {
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                        //TODO: handle error
                    }
                })
            } catch let error {
                //TODO: handle error
                print("getIdForSchool error")
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    static func getIDForScheduleDraft(student: String, date: NSDate, completionHandler: (id: () throws -> String) -> Void) {
        DraftDAO.getIDForScheduleDraft(student, date: date) { (getID) in
            do {
                let id = try getID()
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(id: { () -> String in
                        return id
                    })
                })
            } catch let error {
                print("get scheduleID error")
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                //TODO: handle error
            }
        }
    }
    
    static func getDraftsForStudent(student: String, completionHandler: (getDraft: () throws -> [Post]) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(getDraft: { () -> [Post] in
                throw AccountError.InvalidToken
            })
            return
        }
        SchoolBO.getIdForSchool { (id) in
            do {
                let schoolID = try id()
                StudentBO.getIdForStudent(student, completionHandler: { (id) in
                    do {
                        let studentID = try id()
                        DraftDAO.getDraftsForStudent(student, completionHandler: { (getDrafts) in
                            do {
                                let localDrafts = try getDrafts()
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(getDraft: { () -> [Post] in
                                        return localDrafts
                                    })
                                })
                                DraftMechanism.getDrafts(token, schoolID: schoolID, studentID: studentID, completionHandler: { (info, error, data) in
                                    //error
                                    if let err = error {
                                        //TODO: Handle error data and code
                                        let error = NotificationMessage()
                                        error.setServerError(ErrorBO.decodeServerError(err))
                                        dispatch_async(dispatch_get_main_queue(), {
                                            NinoNotificationManager.sharedInstance.addPostsUpdatedNotification(self, error: error, info: nil)
                                        })
                                    }
                                        //success
                                    else if let array = info {
                                        var serverDrafts = [Post]()
                                        for dict in array {
                                            guard let draftID = dict["draftID"] as? Int else {
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
                                            let draft = Post(id: StringsMechanisms.generateID(), postID: draftID, type: type, date: date, message: message, attachment: nil, targets: [student], readProfileIDs: nil, metadata: metadata)
                                            serverDrafts.append(draft)
                                        }
                                        let comparison = PostBO.comparePosts(serverDrafts, localPosts: localDrafts)
                                        let wasChanged = comparison["wasChanged"]
                                        let wasDeleted = comparison["wasDeleted"]
                                        let newPosts = comparison["newPosts"]
                                        if newPosts!.count > 0 {
                                            for post in newPosts! {
                                                DraftDAO.createDraft(post, completionHandler: { (write) in
                                                    do {
                                                        try write()
                                                        let message = NotificationMessage()
                                                        message.setDataToInsert([post])
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
                                //TODO: handle error
                                print("get local drafts error")
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                            }
                        })
                    } catch let error {
                        //TODO: handle error
                        print("get ID for Student error")
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                })
            } catch let error {
                //TODO: handle error
                print("get ID for School error")
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    static func changeDraftToPost(draft: String, completionHandler: (change: () throws -> Void) -> Void) {
        guard let token = NinoSession.sharedInstance.credential?.token else {
            completionHandler(change: { 
                throw AccountError.InvalidToken
            })
            return
        }
        SchoolBO.getIdForSchool { (id) in
            do {
                let schoolID = try id()
                PostBO.getIdForPost(draft, completionHandler: { (id) in
                    do {
                        let draftID = try id()
                        DraftMechanism.changeDraftToPost(token, schoolID: schoolID, draftID: draftID, completionHandler: { (postID, error, data) in
                            if let err = error {
                                //TODO: handle error data
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(change: { 
                                        throw ErrorBO.decodeServerError(err)
                                    })
                                })
                            } else if let newID = postID {
                                DraftDAO.changeDraftToPost(draft, postID: newID, compltionHandler: { (change) in
                                    do {
                                        try change()
                                        dispatch_async(dispatch_get_main_queue(), { 
                                            completionHandler(change: { 
                                                return
                                            })
                                        })
                                    } catch let error {
                                        //TODO: handle error
                                        print("realm change draft to post error")
                                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                    }
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), { 
                                    completionHandler(change: { 
                                        throw ServerError.UnexpectedCase
                                    })
                                })
                            }
                        })
                    } catch let error {
                        //TODO: handle get post id error
                        print("get post id error")
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                })
            } catch {
                //TODO: handle get id for school error
                print("get id for school error")
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
}
