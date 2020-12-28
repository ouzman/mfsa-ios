//
//  LoginError.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

struct LoginError: Error {
    let provider: LoginProvider
    let description: String
}
