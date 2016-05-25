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
    let id: Int
    let type: String
    let date: NSDate
    let educator: Educator
    var message: String?
    var attachment: NSData?
    var school: School?
    var students: [Student]?
    var phases: [Phase]?
    var rooms: [Room]?
    var read: [Guardian]?

//MARK: Initializer
    /**
     Initialize one post

     - parameter id:         unique identifier
     - parameter type:       type of the post
     - parameter date:       date of the post
     - parameter educator:   creator of the post
     - parameter message:    optional message
     - parameter attachment: optional attachment
     - parameter school:     optional target of school type
     - parameter students:   optional target of student type
     - parameter phases:     optional target of phase type
     - parameter rooms:      optional target of room type
     - parameter read:       optional list of guardians who read

     - returns: struct VO of Post type
     */
    init(id: Int, type: String, date: NSDate, educator: Educator, message: String?, attachment: NSData?, school: School?, students: [Student]?, phases: [Phase]?, rooms: [Room]?, read: [Guardian]?) {
        self.id = id
        self.type = type
        self.date = date
        self.educator = educator
        if let text = message {
            self.message = text
        }
        if let attc = attachment {
            self.attachment = attc
        }
        if let institution = school {
            self.school = institution
        }
        if let babies = students {
            self.students = babies
        }
        if let classes = phases {
            self.phases = classes
        }
        if let places = rooms {
            self.rooms = places
        }
        if let guardians = read {
            self.read = guardians
        }
    }
}
