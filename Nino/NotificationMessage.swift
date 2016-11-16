//
//  NotificationMessage.swift
//  Nino
//
//  Created by Danilo Becke on 26/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class NotificationMessage: NSObject {
    
    private var _target: Any?
    private var _remove: Any?
    private var _update: Any?
    private var _insert: Any?
    private var _serverError: ServerError?
    private var _databaseError: DatabaseError?
    
    var target: Any? {
        return _target
    }
    var dataToRemove: Any? {
        return _remove
    }
    var dataToUpdate: Any? {
        return _update
    }
    var dataToInsert: Any? {
        return _insert
    }
    
    var databaseError: DatabaseError? {
        return _databaseError
    }
    
    var serverError: ServerError? {
        return _serverError
    }
    
    func setTarget(data: Any) {
        self._target = data
    }
    
    func setDataToRemove(data: Any) {
        self._remove = data
    }
    
    func setDataToUpdate(data: Any) {
        self._update = data
    }
    
    func setDataToInsert(data: Any) {
        self._insert = data
    }
    
    func setDatabaseError(error: DatabaseError) {
        self._databaseError = error
    }
    
    func setServerError(error: ServerError) {
        self._serverError = error
    }
    
}
