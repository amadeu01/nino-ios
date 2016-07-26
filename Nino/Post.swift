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
    var postID: Int?
    let type: Int
    var date: NSDate?
    var authorsProfileID: [Int]?
    var message: String?
    var attachment: NSData?
    var studentsProfileID: [Int]?
    var schoolID: Int?
    var phaseID: Int?
    var roomID: Int?
    var readProfileIDs: [Int]?

//MARK: Initializer
    /**
     Initialize one post
     - parameter id:                 post ID
     - parameter postID:             server unique identifier
     - parameter type:               type of the post
     - parameter date:               date of the post
     - parameter authorsProfileID:   creator of the post
     - parameter message:            optional message
     - parameter attachment:         optional attachment
     - parameter schoolID:           optional target of school type
     - parameter studentsProfileID:  optional target of student type
     - parameter phaphaseIDses:      optional target of phase type
     - parameter roomID:             optional target of room type
     - parameter readProfileIDs:     optional list of profiles IDs who read

     - returns: struct VO of Post type
     */
    init(id: String, postID: Int?, type: Int, date: NSDate?, authorsProfileID: [Int]?, message: String?, attachment: NSData?, schoolID: Int?, studentsProfileID: [Int]?, phaseID: Int?, roomID: Int?, readProfileIDs: [Int]?) {
        self.id = id
        if let ptID = postID {
            self.postID = ptID
        }
        self.type = type
        if let dt = date {
            self.date = dt
        }
        if let autProfileID = authorsProfileID {
            self.authorsProfileID = autProfileID
        } else {
            self.authorsProfileID = [Int]()
        }
        if let text = message {
            self.message = text
        }
        if let attc = attachment {
            self.attachment = attc
        }
        if let institution = schoolID {
            self.schoolID = institution
        }
        if let babies = studentsProfileID {
            self.studentsProfileID = babies
        } else {
            self.studentsProfileID = [Int]()
        }
        if let phase = phaseID {
            self.phaseID = phase
        }
        if let places = roomID {
            self.roomID = places
        }
        if let guardians = readProfileIDs {
            self.readProfileIDs = guardians
        } else {
            self.readProfileIDs = [Int]()
        }
    }
}
