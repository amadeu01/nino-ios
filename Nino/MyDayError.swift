//
//  MyDayError.swift
//  Nino
//
//  Created by Danilo Becke on 04/09/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

struct MyDayError: ErrorType {
    let description: String
    
    init (description: String) {
        self.description = description
    }
}