//
//  DatabaseError.swift
//  Nino
//
//  Created by Danilo Becke on 25/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

enum DatabaseError: ErrorType {
    case NotFound
    case MissingID
    case ConflictingIDs
}
