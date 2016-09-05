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
                        DraftMechanism.createDraft(token, schoolID: id, message: message, type: type, profiles: profiles, metadata: metadata, attachment: nil, completionHandler: { (postID, error, data) in
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
            } catch {
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
                //TODO: handle not found or realm error
            }
        }
    }
    
    static func updateDraft(post: String, message: String?, targets: [String]?, metadata: NSDictionary?, attachment: NSData?, completionHandler: (update: () throws -> Post) -> Void) {
        
    }
}
