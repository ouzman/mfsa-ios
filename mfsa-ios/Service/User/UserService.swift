//
//  AppStateService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 28.12.2020.
//

import Combine
import Amplify
import AWSPluginsCore

class UserService {
    static let instance = UserService()
    
    func fetchUserState() -> AnyPublisher<UserState, Never> {
        return Amplify.Auth.fetchAuthSession()
            .resultPublisher
            .map({ session in
                if session.isSignedIn {
                    return .loggedIn
                } else {
                    return .needToLogin
                }
            })
            .replaceError(with: .needToLogin)
            .eraseToAnyPublisher()
    }
    
    // func getCurrentUserSub() -> AnyPublisher<(id: String, sub: String), UserError> {
    func getCurrentUserIds() -> AnyPublisher<(String, String), UserError> {
        return Amplify.Auth.fetchAuthSession()
            .resultPublisher
            .mapError { UserError.authError(error: $0) }
            .flatMap { session -> Future<AuthCognitoIdentityProvider, UserError> in
                return Future<AuthCognitoIdentityProvider, UserError> { promise in
                    if let identityProvider = session as? AuthCognitoIdentityProvider {
                        promise(.success(identityProvider))
                    } else {
                        promise(.failure(UserError.authSessionIsNotCredentialProvider))
                    }
                }
            }
            .flatMap { (provider: AuthCognitoIdentityProvider) -> AnyPublisher<(String, String), UserError> in
                return provider.getIdentityId().publisher
                    .zip(provider.getUserSub().publisher)
                    .mapError { UserError.authError(error: $0) }
                    .map { (id: String, sub: String) -> (id: String, sub: String) in
                        return (id, sub)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
