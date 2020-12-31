//
//  UserError.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

import Amplify

enum UserError: Error {
    case authError(error: AuthError)
    case authSessionIsNotCredentialProvider
    
    var description: String {
        get {
            switch self {
            case .authError(let error):
                return error.errorDescription
            case .authSessionIsNotCredentialProvider:
                return "Current auth session is not a credential provider"
            }
        }
    }
}
