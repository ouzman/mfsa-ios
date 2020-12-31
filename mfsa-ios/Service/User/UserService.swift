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
    
    func getCurrentUserSub() -> AnyPublisher<String, UserError> {
        Amplify.Auth.fetchAuthSession()
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
            .flatMap { (provider: AuthCognitoIdentityProvider) -> AnyPublisher<String, UserError> in
                return provider.getIdentityId()
                    .publisher
                    .mapError { UserError.authError(error: $0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
