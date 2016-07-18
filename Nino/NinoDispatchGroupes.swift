//
//  NinoDispatchGroupes.swift
//  Nino
//
//  Created by Danilo Becke on 18/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

//TODO: make a method that returns one empty group

class NinoDispatchGroupes: NSObject {
    
    
    static private let first: dispatch_group_t = dispatch_group_create()
    static private let second: dispatch_group_t = dispatch_group_create()
    static private let third: dispatch_group_t = dispatch_group_create()
    
    static func getGroup(value: Int) -> dispatch_group_t {
        switch value {
        case 0:
            return self.first
        case 1:
            return self.second
        case 2:
            return self.third
        //FIXME: fix default return
        default:
            return self.third
        }
    }
}
