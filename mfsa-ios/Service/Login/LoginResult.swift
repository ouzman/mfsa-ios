//
//  LoginResult.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import Foundation

enum LoginResult {
    case success
    case failure(provider: LoginProvider, error: LocalizedError)
}
