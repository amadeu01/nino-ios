//
//  ServerError.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

enum ServerError: ErrorType {
    case Timeout
    case BadRequest
    case Unauthorized
    case Forbidden
    case NotFound
    case ServerError
    case CouldNotConnectToTheServer
    case InternetConnectionOffline
    case LostNetworkConnection
}
