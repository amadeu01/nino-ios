//
//  PostDAO.swift
//  Nino
//
//  Created by Danilo Becke on 22/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import RealmSwift

class PostDAO: NSObject {
    
    private override init() {
        super.init()
    }
    
    static func createPost(post: Post, completionHandler: (write: () throws -> Void) -> Void) {
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
                postRealmObject.postID.value = post.postID
                postRealmObject.type = post.type
                postRealmObject.message = post.message
                postRealmObject.attachment = post.attachment
                postRealmObject.date = post.date
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
                    postRealmObject.targetsPost.append(target)
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
    
    static func upatePostID(id: String, serverID: Int, completionHandler: (update: () throws -> Void) -> Void) {
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
    
    static func updatePostDate(post: String, date: NSDate, completionHandler: (update: () throws -> Void) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) { 
            do {
                let realm = try Realm()
                let postRealm = realm.objectForPrimaryKey(PostRealmObject.self, key: post)
                guard let selectedPost = postRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(update: { 
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                try realm.write({ 
                    selectedPost.date = date
                    realm.add(selectedPost, update: true)
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
    
    static func getPostsForStudent(student: String, completionHandler: (getPosts: () throws -> [Post]) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let studentRealm = realm.objectForPrimaryKey(StudentRealmObject.self, key: student)
                guard let selectedStudent = studentRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(getPosts: { () -> [Post] in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                let postsRealm = selectedStudent.posts
                var posts = [Post]()
                for post in postsRealm {
                    var dictionary: NSDictionary?
                    if let data = post.metadata {
                        do {
                            dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        } catch {
                            dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                                completionHandler(getPosts: { () -> [Post] in
                                    throw RealmError.UnexpectedCase
                                })
                            })
                        }
                    }
                    let postVO = Post(id: post.id, postID: post.postID.value, type: post.type, date: post.date, message: post.message, attachment: post.attachment, targets: [student], readProfileIDs: nil, metadata: dictionary)
                    posts.append(postVO)
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(getPosts: { () -> [Post] in
                        return posts
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                    completionHandler(getPosts: { () -> [Post] in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
    static func getIdForPost(post: String, completionHandler: (id: () throws -> Int) -> Void) {
        dispatch_async(RealmManager.sharedInstace.getRealmQueue()) {
            do {
                let realm = try Realm()
                let postRealm = realm.objectForPrimaryKey(PostRealmObject.self, key: post)
                guard let selectedPost = postRealm else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                        completionHandler(id: { () -> Int in
                            throw DatabaseError.NotFound
                        })
                    })
                    return
                }
                guard let id = selectedPost.postID.value else {
                    dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), {
                        completionHandler(id: { () -> Int in
                            throw DatabaseError.MissingID
                        })
                    })
                    return
                }
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(id: { () -> Int in
                        return id
                    })
                })
            } catch {
                dispatch_async(RealmManager.sharedInstace.getDefaultQueue(), { 
                    completionHandler(id: { () -> Int in
                        throw RealmError.CouldNotCreateRealm
                    })
                })
            }
        }
    }
    
}
