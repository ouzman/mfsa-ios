//
//  FacebookLoginError.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import Foundation

enum FacebookLoginError : Error{
    case wrapped(_ error: Error)
    case cancelled
    case unsufficientPermission
}

extension FacebookLoginError : LocalizedError {
    var errorDescription: String? {
        get {
            switch self {
            case .wrapped(let error):
                return error.localizedDescription
            case .cancelled:
                return "Need to login to use the application"
            case .unsufficientPermission:
                return "Need to permit to read email address to use the application"
            }
        }
    }
}

