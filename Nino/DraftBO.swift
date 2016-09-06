//
//  DraftBO.swift
//  Nino
//
//  Created by Danilo Becke on 05/09/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

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
                                            } catch {
                                                print("update error")
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
            } catch {
                print("getschoolID error")
                //TODO: handle getSchoolID error
            }
        }
    }
    
    static func shouldCreateScheduleDraft(student: String, date: NSDate, completionHandler: (shouldCreate: () throws -> Bool) -> Void) {
        DraftDAO.isThereScheduleForStudentAndDate(student, date: date) { (isThere) in
            do {
                let shouldCreate = try !isThere()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(shouldCreate: { () -> Bool in
                        return shouldCreate
                    })
                })
            } catch {
                print("not found error")
                //TODO: handle not found or realm error
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
                                    else if let done = updated {
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
                            } catch {
                                print("realmError")
                                //TODO: handle local errors
                            }
                        }
                    } catch {
                        //TODO: handle error
                    }
                })
            } catch {
                //TODO: handle error
                print("getIdForSchool error")
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
            } catch {
                print("get scheduleID error")
                //TODO: handle error
            }
        }
    }
}
