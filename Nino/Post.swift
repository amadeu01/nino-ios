//
//  Post.swift
//  Nino
//
//  Created by Danilo Becke on 20/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

/**
 *  VO representing one Post
 */
struct Post {

//MARK: Attributes
    let id: String
    let postID: Int?
    let type: Int
    let date: NSDate?
    let message: String
    let attachment: NSData?
    let targets: [String]
    let readProfileIDs: [String]?
    let metadata: NSDictionary?

//MARK: Initializer
    /**
     Initialize one post
     - parameter id:                 post ID
     - parameter postID:             server unique identifier
     - parameter type:               type of the post
     - parameter date:               date of the post
     - parameter message:            message
     - parameter attachment:         optional attachment
     - parameter targets:            optional targets
     - parameter readProfileIDs:     optional list of profiles IDs who read

     - returns: struct VO of Post type
     */
    init(id: String, postID: Int?, type: Int, date: NSDate?, message: String, attachment: NSData?, targets: [String], readProfileIDs: [String]?, metadata: NSDictionary?) {
        self.id = id
        self.postID = postID
        self.type = type
        self.date = date
        self.message = message
        self.attachment = attachment
        self.targets = targets
        self.metadata = metadata
        if let guardians = readProfileIDs {
            self.readProfileIDs = guardians
        } else {
            self.readProfileIDs = [String]()
        }
    }
}
