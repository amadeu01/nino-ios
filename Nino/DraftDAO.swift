//
//  DraftDAO.swift
//  Nino
//
//  Created by Danilo Becke on 05/09/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class DraftDAO: NSObject {

    private override init() {
        super.init()
    }
    
    static func createDraft(post: Post, completionHandler: (write: () throws -> Void) -> Void) {
        var metadata: NSData?
        if let data = post.metadata {
            do {
                metadata = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
            } catch {
                completionHandler(write: {
                    throw RealmError.UnexpectedCase
                })
            }
        }
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let postRealmObject = PostRealmObject()
                postRealmObject.id = post.id
                postRealmObject.type = post.type
                postRealmObject.message = post.message
                postRealmObject.attachment = post.attachment
                postRealmObject.metadata = metadata
                for student in post.targets {
                    let realmStundet = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                    guard let target = realmStundet else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(write: {
                                throw DatabaseError.NotFound
                            })
                        })
                        return
                    }
                    postRealmObject.targetsDraft.append(target)
                }
                try realm.write({
                    realm.add(postRealmObject)
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(write: {
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(write: {
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func upateDraftID(id: String, serverID: Int, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let postRealm = realm.objectForPrimaryKey(PostRealmObject.self, key: id)
                guard let post = postRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(update: {
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                try realm.write({
                    post.postID.value = serverID
                    realm.add(post, update: true)
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(update: {
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(update: {
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func isThereScheduleForStudentAndDate(student: String, date: NSDate, completionHandler: (isThere: () throws -> Bool) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let studentRealm = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = studentRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(isThere: { () -> Bool in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let realmDrafts = selectedStudent.drafts
                let filter = NSPredicate(format: "type = %d", PostTypes.Schedule.rawValue)
                let scheduleDrafts = realmDrafts.filter(filter)
                var selectedDraft: PostRealmObject?
                for draft in scheduleDrafts {
                    //TODO: check date here
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(isThere: { () -> Bool in
                        return selectedDraft != nil
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(isThere: { () -> Bool in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func updateDraft(draft: String, message: String?, targets: [String]?, metadata: NSDictionary?, attachment: NSData?, completionHandler: (update: () throws -> Post) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let draftRealm = realm.objectForPrimaryKey(PostRealmObject.self, key: draft)
                guard let selectedDraft = draftRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(update: { () -> Post in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                if let newMessage = message {
                    try realm.write({ 
                        selectedDraft.message = newMessage
                    })
                }
                if let newMetadata = metadata {
                    try realm.write({ 
//                        selectedDraft.metadata = metadata
                    })
                }
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(update: { () -> Post in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
}
