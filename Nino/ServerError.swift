//
//  ServerError.swift
//  Nino
//
//  Created by Danilo Becke on 06/06/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import Foundation

enum ServerError: ErrorType {
    case InexistentRegister
    case DeletedRegister
    case CouldNotConnectToTheServer
    case InternetConnectionOffline
    case LostNetworkConnection
    case MissingParameters
    case BadForm
    case InvalidPermissions
    case InvalidCredential
    case ExpiredCredential
    case Duplicate
    case UnexpectedCase
    
    func description() -> String {
        switch self {
        case .InexistentRegister:
            return "Usuário ou senha inválidos."
        case .DeletedRegister:
            return "Esse registro foi deletado."
        case .CouldNotConnectToTheServer:
            return "Ocorreu um erro interno. Seu problema foi reportado, aguarde cerca de 5 minutos e tente novamente."
        case .InvalidPermissions:
            return "Permissão Inválida."
        case .InvalidCredential:
            return "Credencial Invalida"
        case .ExpiredCredential:
            return "Credencial expirada"
        case .Duplicate:
            return "Registro já existente"
        case .InternetConnectionOffline:
            return "Sua conexão com a internet parece estar offline. Cheque-a e tente novamente."
        case .LostNetworkConnection, .UnexpectedCase, .MissingParameters, .BadForm:
            return "Ocorreu um erro, tente novamente. Se o problema persistir, entre em contato através de contato@ninoapp.com.br"
        }
    }
}
