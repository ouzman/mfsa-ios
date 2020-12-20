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

extension Publisher where Failure == CognitoLoginError {
    func mapErrorToLoginError() -> AnyPublisher<Self.Output, LoginError> {
        self
            .mapError { (error: Self.Failure) -> LoginError in
                LoginError(provider: .cognito, error: error as LocalizedError)
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == FacebookLoginError {
    func mapErrorToLoginError() -> AnyPublisher<Self.Output, LoginError> {
        self
            .mapError { (error: Self.Failure) -> LoginError in
                LoginError(provider: .facebook, error: error as LocalizedError)
            }
            .eraseToAnyPublisher()
    }
}
