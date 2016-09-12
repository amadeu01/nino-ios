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
                postRealmObject.date = post.date
                postRealmObject.postID.value = post.postID
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
                for draft in scheduleDrafts {
                    if let draftDate = draft.date {
                        if NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: draftDate) {
                            dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                                completionHandler(isThere: { () -> Bool in
                                    return true
                                })
                            })
                            return
                        }
                    } else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(isThere: { () -> Bool in
                                throw DatabaseError.MissingDate
                            })
                        })
                    }
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(isThere: { () -> Bool in
                        return false
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
                        do {
                            let data = try NSJSONSerialization.dataWithJSONObject(newMetadata, options: .PrettyPrinted)
                            try realm.write({
                                selectedDraft.metadata = data
                            })
                        } catch {
                            dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                                completionHandler(update: { () -> Post in
                                    throw RealmError.UnexpectedCase
                                })
                            })
                        }
                }
                if let newAttachment = attachment {
                    try realm.write({ 
                        selectedDraft.attachment = attachment
                    })
                }
                if let newTargets = targets {
                    for student in newTargets {
                        let realmStundet = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                        guard let target = realmStundet else {
                            dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                                completionHandler(update: { () -> Post in
                                    throw DatabaseError.NotFound
                                })
                            })
                            return
                        }
                        try realm.write({ 
                            selectedDraft.targetsDraft.append(target)
                        })
                    }
                }
                try realm.write({ 
                    realm.add(selectedDraft, update: true)
                })
                var currentTargets = [String]()
                for student in selectedDraft.targetsDraft {
                    currentTargets.append(student.id)
                }
                var currentRead = [String]()
                for readProfile in selectedDraft.readGuardians {
                    currentRead.append(readProfile.id)
                }
                var dictionary: NSDictionary?
                if let data = selectedDraft.metadata {
                    do {
                        dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    } catch {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                            completionHandler(update: { () -> Post in
                                throw RealmError.UnexpectedCase
                            })
                        })
                    }
                }
                let post = Post(id: draft, postID: selectedDraft.postID.value, type: selectedDraft.type, date: selectedDraft.date, message: selectedDraft.message, attachment: selectedDraft.attachment, targets: currentTargets, readProfileIDs: currentRead, metadata: dictionary)
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(update: { () -> Post in
                        return post
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(update: { () -> Post in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getIDForScheduleDraft(student: String, date: NSDate, completionHandler: (getID: () throws -> String) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let realmStudent = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = realmStudent else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(getID: { () -> String in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let drafts = selectedStudent.drafts
                let filter = NSPredicate(format: "type == %d", PostTypes.Schedule.rawValue)
                let selectedDrafts = drafts.filter(filter)
                var id: String?
                for draft in selectedDrafts {
                    if let draftDate = draft.date {
                        if NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: draftDate) {
                            id = draft.id
                        }
                    } else {
                        dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                            completionHandler(getID: { () -> String in
                                throw DatabaseError.MissingDate
                            })
                        })
                        return
                    }
                }
                if id == nil {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(getID: { () -> String in
                            throw DatabaseError.NotFound
                        })
                    })
                } else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(getID: { () -> String in
                            return id!
                        })
                    })
                }
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(getID: { () -> String in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getDraftsForStudent(student: String, completionHandler: (getDrafts: () throws -> [Post]) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let studentRealm = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = studentRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(getDrafts: { () -> [Post] in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let draftsRealm = selectedStudent.drafts
                var drafts = [Post]()
                for draft in draftsRealm {
                    var dictionary: NSDictionary?
                    if let data = draft.metadata {
                        do {
                            dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        } catch {
                            dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                                completionHandler(getDrafts: { () -> [Post] in
                                    throw RealmError.UnexpectedCase
                                })
                            })
                        }
                    }
                    let draftVO = Post(id: draft.id, postID: draft.postID.value, type: draft.type, date: draft.date, message: draft.message, attachment: draft.attachment, targets: [student], readProfileIDs: nil, metadata: dictionary)
                    drafts.append(draftVO)
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(getDrafts: { () -> [Post] in
                        return drafts
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(getDrafts: { () -> [Post] in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func changeDraftToPost(draft: String, postID: Int, compltionHandler: (change: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let drafRealm = realm.objectForPrimaryKey(PostRealmObject.self, key: draft)
                guard let selectedDraft = drafRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        compltionHandler(change: { 
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                var index = 0
                try realm.write({ 
                    for target in selectedDraft.targetsDraft {
                        selectedDraft.targetsDraft.removeAtIndex(index)
                        selectedDraft.targetsPost.append(target)
                        index += 1
                    }
                    selectedDraft.postID.value = postID
                    realm.add(selectedDraft, update: true)
                })
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    compltionHandler(change: { 
                        return
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    compltionHandler(change: { 
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getScheduleDraft(student: String, date: NSDate, completionHandler:(getSchedule: () throws -> Post?) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let studentRealm = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = studentRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(getSchedule: { () -> Post in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let filter = NSPredicate(format: "type = %d", PostTypes.Schedule.rawValue)
                let drafts = selectedStudent.drafts.filter(filter)
                var selectedDraftRealm: PostRealmObject?
                for draft in drafts {
                    if let postDate = draft.date {
                        if NSCalendar.currentCalendar().isDate(postDate, inSameDayAsDate: date) {
                            selectedDraftRealm = draft
                            break
                        }
                    }
                }
                var selectedDraft: Post?
                if let draft = selectedDraftRealm {
                    var targets = [String]()
                    for student in draft.targetsDraft {
                        targets.append(student.id)
                    }
                    var profiles = [String]()
                    for profile in draft.readGuardians {
                        profiles.append(profile.id)
                    }
                    var dict: NSDictionary?
                    if let data = draft.metadata {
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        } catch {
                            dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                                completionHandler(getSchedule: { () -> Post? in
                                    throw RealmError.UnexpectedCase
                                })
                            })
                        }
                    }
                    selectedDraft = Post(id: draft.id, postID: draft.postID.value, type: draft.type, date: draft.date, message: draft.message, attachment: draft.attachment, targets: targets, readProfileIDs: profiles, metadata: dict)
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(getSchedule: { () -> Post? in
                            return selectedDraft
                        })
                    })
                }
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(getSchedule: { () -> Post? in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
}
