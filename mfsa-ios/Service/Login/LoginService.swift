//
//  LoginService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import Combine
import Foundation
import AWSMobileClient
import FBSDKLoginKit

class LoginService {
    private let facebookUserLoginManager = FacebookUserLoginManager()
    private let cognitoLoginManager = CognitoLoginManager()

    static let instance = LoginService()

    private init() { }
    
    func facebookLogin() -> AnyPublisher<LoginResult, Never> {
        return facebookUserLoginManager.login()
            .mapErrorToLoginError()
            .flatMap { self.cognitoLoginManager.federatedSignIn(with: $0.tokenString).mapErrorToLoginError() }
            .map { _ in LoginResult.success }
            .catch({ (loginError: LoginError) in
                return Just(LoginResult.failure(provider: loginError.provider, error: loginError.error))
            })
            .eraseToAnyPublisher()
    }
    
    func userLoggedIn() -> Bool {
        return AWSMobileClient.default().currentUserState == .signedIn
            && AccessToken.current != nil
            && AccessToken.current?.isExpired == false
    }
}
