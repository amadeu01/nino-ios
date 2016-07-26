//
//  PostBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of post
class PostBO: NSObject {

    /**
     Tries to creat a post

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

     - throws: error of CreationError.ContentNotFound or CreationError.TargetNotFound type

     - returns: struct VO of Post type
     */
    static func createPost(id: Int, type: String, date: NSDate, educator: Educator, message: String?, attachment: NSData?, school: School?, students: [Student]?, phases: [Phase]?, rooms: [Room]?, read: [Guardian]?) throws -> Post {

        if message == nil && attachment == nil {
            throw CreationError.ContentNotFound
        }
        if school == nil && students == nil && phases == nil && rooms == nil {
            throw CreationError.TargetNotFound
        }
        
        let targets: [Any?] = [school, students, phases, rooms]
        var numberOfTargets = 0
        
        for target in targets {
            if target != nil {
                numberOfTargets += 1
            }
        }
        
        if numberOfTargets > 1 {
            throw CreationError.MultipleTargets
        }
        
        return Post(id: StringsMechanisms.generateID(), postID: id, type: 0, date: nil, authorsProfileID: nil, message: "asd", attachment: nil, schoolID: nil, studentsProfileID: nil, phaseID: 213, roomID: nil, readProfileIDs: nil)
    }
}
