//
//  ErrorBO.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of errors
class ErrorBO: NSObject {

    /**
     Decodes server errors
     
     - parameter code: error code priveded by the server
     
     - returns: error of ServerError type
     */
    static func decodeServerError(code: Int) -> ServerError {
        var error: ServerError
        switch code {
        case -1009:
            error = ServerError.InternetConnectionOffline
        case -1004:
            error = ServerError.CouldNotConnectToTheServer
        case 400:
           error = ServerError.BadRequest
        case 401:
            error = ServerError.Unauthorized
        case 403:
            error = ServerError.Forbidden
        case 404:
            error = ServerError.NotFound
        case 500:
            error = ServerError.ServerError
        default:
            error = ServerError.ServerError
        }
        return error
    }
    
    static func decodeNSURLError(error: NSError) {
        
    }
    
}
