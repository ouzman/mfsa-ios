//
//  CognitoLoginManager.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import Combine
import AWSMobileClient

final class CognitoLoginManager {
    
    func federatedSignIn(with facebookToken: String) -> Future<UserState, CognitoLoginError> {
        return self.federatedSignIn(provider: .facebook, token: facebookToken)
    }
    
    private func federatedSignIn(provider: IdentityProvider, token: String) -> Future<UserState, CognitoLoginError> {
        return Future<UserState, CognitoLoginError> { (promise) in
            AWSMobileClient
                .default()
                .federatedSignIn(providerName: provider.rawValue, token: token) { (userState, error) in
                    if let error = error {
                        promise(.failure(CognitoLoginError.wrapped(error)))
                        return
                    } else {
                        guard let userState = userState else {
                            promise(.failure(CognitoLoginError.unkown))
                            return
                        }
                        if .signedIn != userState {
                            promise(.failure(CognitoLoginError.unkown))
                            return
                        }
                        promise(.success(userState))
                    }
                }
        }
    }
    
    func logout() {
        AWSMobileClient.default().clearKeychain()
        AWSMobileClient.default().clearCredentials()
    }
}
