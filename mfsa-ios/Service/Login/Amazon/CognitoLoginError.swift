//
//  CognitoLoginError.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import Foundation
import AWSMobileClient

enum CognitoLoginError: Error {
    case wrapped(_ error: Error)
    case invalidUserState(_ userState: UserState)
    case unkown
}

extension CognitoLoginError: LocalizedError {
    var errorDescription: String? {
        get {
            switch self {
            case .wrapped(let error):
                return error.localizedDescription
            case .invalidUserState(let userState):
                return "Invalid user state: \(userState.rawValue)"
            case .unkown:
                return "Unknown error"
            }
        }
    }
    
}
