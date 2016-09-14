//
//  SchoolSession.swift
//  Nino
//
//  Created by Carlos Eduardo Millani on 8/16/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

class SchoolSession {
    static var currentStudent: String?
    static var studentCreatedAt: NSDate?
    static var currentRoom: String?
    static var currentPhase: String?
    
    static func clearSession() {
        self.currentStudent = nil
        self.studentCreatedAt = nil
        self.currentRoom = nil
        self.currentPhase = nil
    }
}
