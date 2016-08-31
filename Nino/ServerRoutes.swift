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
    case SendSchoolLogo
    case Login
    case GetMyProfile
    case GetSchool
    case GetPhases
    case CreatePhase
    case GetAllRooms
    case GetRooms
    case CreateRoom
    case GetStudents
    case CreateStudent
    case CreateGuardian
    case GetGuardians
    case CreatePost

// swiftlint:disable cyclomatic_complexity
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
        case .SendSchoolLogo:
            guard let id = param where id.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "schools/" + id[0] + "/logotype"
        case .Login:
            return "accounts/authentication"
        case .GetMyProfile:
            return "profiles/me"
        case .GetSchool:
            return "schools/me"
        case .GetPhases, .CreatePhase:
            guard let id = param where id.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "classes/schools/" + id[0]
        case .GetRooms, .CreateRoom:
            guard let id = param where id.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "rooms/classes/" + id[0]
        case .GetStudents:
            guard let id = param where id.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "students/rooms/" + id[0]
        case .CreateStudent:
            guard let id = param where id.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "students/schools/" + id[0]
        case .GetAllRooms:
            guard let id = param where id.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "rooms/schools/" + id[0]
        case .CreateGuardian:
            return "guardians"
        case .GetGuardians:
            guard let id = param where id.count > 0 else {
                throw RouteError.MissingParameter
            }
            return "guardians/students/" + id[0]
        case .CreatePost:
            return "posts"
        }
    }
}
