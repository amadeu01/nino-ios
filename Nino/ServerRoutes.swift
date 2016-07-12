//
//  ServerRoutes.swift
//  Nino
//
//  Created by Danilo Becke on 06/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

enum ServerRoutes {
    case CreateUser
    case CheckIfValidated
    case ConfirmAccount
    case CreateSchool
    case Login
    
    func description(param: [String]?) throws -> String {
        switch self {
        case .CreateUser:
            return "accounts"
        case .CheckIfValidated, .ConfirmAccount:
            guard let hash = param where hash.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "accounts/authentication/" + hash[0]
        case .CreateSchool:
            return "schools"
        case .Login:
            return "accounts/authentication"
        }
    }
}
