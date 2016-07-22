//
//  PhaseDAO.swift
//  Nino
//
//  Created by Danilo Becke on 22/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class PhaseDAO: NSObject {
    
    static let sharedInstance = PhaseDAO()
    
    private var phases = [Phase]()
    
    override private init() {
        super.init()
    }

//    func addPhases(phases: [Phase], completionHandler: () -> Void) {
//        for phase in phases {
//            let newPhase = PhaseRealmObject()
//            newPhase.school =
//        }
//    }
}
