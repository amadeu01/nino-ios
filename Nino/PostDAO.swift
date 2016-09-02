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
    
}
