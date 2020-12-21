//
//  LoginError.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import Foundation
import Combine

struct LoginError: Error {
    let provider: LoginProvider
    let error: LocalizedError
}
