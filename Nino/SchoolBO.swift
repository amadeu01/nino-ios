//
//  SchoolBO.swift
//  Nino
//
//  Created by Danilo Becke on 24/05/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

/// Class which manages all services of school
class SchoolBO: NSObject {
    
    /**
     Tries to create a school
     
     - parameter token:             user token
     - parameter name:              school's name
     - parameter address:           school's address
     - parameter telephone:         school's phone
     - parameter email:             school's main email
     - parameter logo:              optional school's logo
     - parameter completionHandler: completionHandler with other inside. The completionHandler from inside can throws ServerError or returns a School
     
     - throws: error of CreationError.InvalidEmail type
     */
    static func createSchool(token: String, name: String, address: String, telephone: String, email: String, logo: NSData?, completionHandler: (getSchool: () throws -> School) -> Void) throws {

        if !StringsMechanisms.isValidEmail(email) {
            throw CreationError.InvalidEmail
        }
        
        let newSchool = School(id: StringsMechanisms.generateID(), schoolId: nil, name: name, address: address, legalNumber: nil, telephone: telephone, email: email, owner: nil, logo: logo)
        
        SchoolDAO.createSchool(newSchool) { (writeSchool) in
            do {
                //local creation
                try writeSchool()
                //server creation
                SchoolMechanism.createSchool(token, name: name, address: address, telephone: telephone, email: email, logo: logo, completionHandler: { (schoolID, error, data) in
                    if let errorType = error {
                        //TODO: handle error data
                        dispatch_async(dispatch_get_main_queue(), { 
                            completionHandler(getSchool: { () -> School in
                                throw ErrorBO.decodeServerError(errorType)
                            })
                        })
                    }
                    //success
                    else if let school = schoolID {
                        //update local schoolID information
                        SchoolDAO.updateSchoolId(school, completionHandler: { (update) in
                            do {
                                try update()
                                //has profile image
                                if let imageData = logo {
                                    SchoolDAO.updateSchoolLogo(imageData, completionHandler: { (update) in
                                        do {
                                            try update()
                                            //tries to send the profile image
                                            SchoolMechanism.sendProfileImage(token, imageData: imageData, schoolID: school, completionHandler: { (success, error, data) in
                                                if let err = error {
                                                    dispatch_async(dispatch_get_main_queue(), { 
                                                        completionHandler(getSchool: { () -> School in
                                                            throw ErrorBO.decodeServerError(err)
                                                        })
                                                    })
                                                }
                                                //success
                                                else if let success = success {
                                                    if success {
                                                        dispatch_async(dispatch_get_main_queue(), { 
                                                            completionHandler(getSchool: { () -> School in
                                                                return School(id: newSchool.id, schoolId: school, name: newSchool.name, address: newSchool.address, legalNumber: newSchool.legalNumber, telephone: newSchool.telephone, email: newSchool.email, owner: newSchool.owner, logo: imageData)
                                                            })
                                                        })
                                                    }
                                                } else {
                                                    dispatch_async(dispatch_get_main_queue(), { 
                                                        completionHandler(getSchool: { () -> School in
                                                            throw ServerError.UnexpectedCase
                                                        })
                                                    })
                                                }
                                            })
                                        } catch let error {
                                            //TODO: update logo error
                                            NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                        }
                                    })
                                }
                                //without profile image
                                else {
                                    dispatch_async(dispatch_get_main_queue(), { 
                                        completionHandler(getSchool: { () -> School in
                                            return School(id: newSchool.id, schoolId: school, name: newSchool.name, address: newSchool.address, legalNumber: newSchool.legalNumber, telephone: newSchool.telephone, email: newSchool.email, owner: newSchool.owner, logo: newSchool.logo)
                                        })
                                    })
                                }
                            } catch let error {
                                //TODO: update ID error
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                            }
                        })
                    }
                    //unexpected case
                    else {
                        dispatch_async(dispatch_get_main_queue(), { 
                            completionHandler(getSchool: { () -> School in
                                throw ServerError.UnexpectedCase
                            })
                        })
                    }

                })
            } catch let error {
                //TODO: realm error create school
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }
        }
    }
    
    static func getSchoolWithID(token: String, schoolID: Int, completionHandler: (school: () throws -> School) -> Void) {
        SchoolDAO.getLocalIdForSchool(schoolID) { (get) in
            do {
                let schoolID = try get()
                SchoolDAO.getSchoolWithID(schoolID) { (getSchool) in
                    do {
                        let school = try getSchool()
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(school: { () -> School in
                                return school
                            })
                        })
                    } catch let error {
                        //TODO Handle error
                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                    }
                }
            } catch let error {
                if let dataBaseError = error as? DatabaseError {
                    //There's no Room. Let's Get and create one
                    if dataBaseError == DatabaseError.NotFound {
                        guard let token = NinoSession.sharedInstance.credential?.token else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(school: { () -> School in
                                    throw AccountError.InvalidToken
                                })
                            })
                            return
                        }
                        SchoolMechanism.getSchoolWithID(token, schoolID: schoolID, completionHandler: { (info, error, data) in
                            if let errorType = error {
                                //TODO: Handle error data and code
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(school: { () -> School in
                                        throw ErrorBO.decodeServerError(errorType)
                                    })
                                })
                            } else if let schoolInfo = info {
                                let id = schoolInfo["schoolID"] as? Int
                                let name = schoolInfo["name"] as? String
                                let email = schoolInfo["email"] as? String
                                let address = schoolInfo["address"] as? String
                                let telephone = schoolInfo["telephone"] as? String
                                
                                guard let schoolID = id else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        completionHandler(school: { () -> School in
                                            throw ServerError.UnexpectedCase
                                        })
                                    })
                                    return
                                }
                                guard let schoolName = name else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        completionHandler(school: { () -> School in
                                            throw ServerError.UnexpectedCase
                                        })
                                    })
                                    return
                                }
                                guard let schoolEmail = email else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        completionHandler(school: { () -> School in
                                            throw ServerError.UnexpectedCase
                                        })
                                    })
                                    return
                                }
                                guard let schoolAddress = address else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        completionHandler(school: { () -> School in
                                            throw ServerError.UnexpectedCase
                                        })
                                    })
                                    return
                                }
                                guard let schoolTelephone = telephone else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        completionHandler(school: { () -> School in
                                            throw ServerError.UnexpectedCase
                                        })
                                    })
                                    return
                                }
                                
                                let schoolVO = School(id: StringsMechanisms.generateID(), schoolId: schoolID, name: schoolName, address: schoolAddress, legalNumber: nil, telephone: schoolTelephone, email: schoolEmail, owner: nil, logo: nil)
                                //TODO Solve this stuff here plis
                                
                                SchoolDAO.createSchool(schoolVO, completionHandler: { (writeSchool) in
                                    do {
                                        try writeSchool()
                                        dispatch_async(dispatch_get_main_queue(), {
                                            completionHandler(school: { () -> School in
                                                return schoolVO
                                            })
                                        })
                                    } catch let error {
                                        //TODO Handle error
                                        NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                    }
                                })
                            }
                                //unexpected case
                            else {
                                //TODO Handle error - Halp Becke
                            }
                        })
                    }
                }
            }
        }
    }
    
    static func getSchool(token: String, completionHandler: (school: () throws -> School) -> Void) {
        
        SchoolDAO.getSchool { (school) in
            do {
                let school = try school()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(school: { () -> School in
                        return school
                    })
                })
            } catch let error {
                if (error as? DatabaseError) == DatabaseError.NotFound {
                    SchoolMechanism.getSchool(token, completionHandler: { (info, error, data) in
                        //TODO: handle error data
                        if let error = error {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(school: { () -> School in
                                    throw ErrorBO.decodeServerError(error)
                                })
                            })
                        }
                        //FIXME: handle other schools
                        guard let firstSchool = info?.first else {
                            dispatch_async(dispatch_get_main_queue(), { 
                                completionHandler(school: { () -> School in
                                    throw DatabaseError.NotFound
                                })
                            })
                            return
                        }
                        //Unexpected cases
                        guard let schoolID = (firstSchool["id"] as? Int) else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(school: { () -> School in
                                    throw ServerError.UnexpectedCase
                                })
                            })
                            return
                        }
                        guard let schoolName = (firstSchool["name"] as? String) else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(school: { () -> School in
                                    throw ServerError.UnexpectedCase
                                })
                            })
                            return
                        }
                        guard let schoolEmail = (firstSchool["email"] as? String) else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(school: { () -> School in
                                    throw ServerError.UnexpectedCase
                                })
                            })
                            return
                        }
                        guard let schoolPhone = (firstSchool["telephone"] as? String) else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(school: { () -> School in
                                    throw ServerError.UnexpectedCase
                                })
                            })
                            return
                        }
                        guard let schoolAddr = (firstSchool["address"] as? String) else {
                            dispatch_async(dispatch_get_main_queue(), {
                                completionHandler(school: { () -> School in
                                    throw ServerError.UnexpectedCase
                                })
                            })
                            return
                        }
                        //success
                        let currentSchool = School(id: StringsMechanisms.generateID(), schoolId: schoolID, name: schoolName, address: schoolAddr, legalNumber: nil, telephone: schoolPhone, email: schoolEmail, owner: nil, logo: nil)
                        SchoolDAO.createSchool(currentSchool, completionHandler: { (writeSchool) in
                            do {
                                try writeSchool()
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(school: { () -> School in
                                        return currentSchool
                                    })
                                })
                            } catch let error {
                                print("realm school error")
                                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
                                //TODO: post notification
                            }
                        })
                    }) //end get school
                }//end school NotFound
                //realm error
                else {
                    print("realm error")
                    //TODO: handle realm error
                }
            } //end catch
        } //end DAO getSchool

    }
    
    
    static func getIdForSchool(completionHandler: (id: () throws -> Int) -> Void) {
        SchoolDAO.getIdForSchool { (id) in
            do {
                let schoolID = try id()
                dispatch_async(dispatch_get_main_queue(), { 
                    completionHandler(id: { () -> Int in
                        return schoolID
                    })
                })
            } catch let error {
                guard let databaseError = error as? DatabaseError else {
                    //TODO: handle realm error
                    return
                }
                switch databaseError {
                case .NotFound, .ConflictingIDs:
                    //TODO: logout
                    break
                case .MissingID:
                    //TODO: getSchool
                    break
                default:
                    //TODO: explode the app
                    break
                }
                NinoSession.sharedInstance.kamikaze(["error":"\(error)", "description": "File: \(#file), Function: \(#function), line: \(#line)"])
            }//end catch
        }//end DAO method
    }
}
