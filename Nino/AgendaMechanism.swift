//
//  AgendaMechanism.swift
//  Nino
//
//  Created by Danilo Becke on 09/08/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class AgendaMechanism: NSObject {
    
    static func getSectionsForAgenda(id: Int) -> (left: [Int], right: [Int]) {
        switch id {
        case 0:
            return self.getNurseryAgenda()
        case 1:
            return self.getPreSchoolAgenda()
        default:
            return self.getNurseryAgenda()
        }
    }
    
    private static func getNurseryAgenda() -> (left: [Int], right: [Int]) {
        var left: [Int]
        left = [0]
        var right: [Int]
        right = [1, 2]
        return (left, right)
    }
    
    private static func getPreSchoolAgenda() -> (left: [Int], right: [Int]) {
        var left: [Int]
        left = [3]
        var right: [Int]
        right = [4]
        return (left, right)
    }
}
