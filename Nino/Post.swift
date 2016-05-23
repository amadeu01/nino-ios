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
    
}
