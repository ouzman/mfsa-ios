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
        print("Amazon default.identityId: \(AWSMobileClient.default().identityId ?? "yok")")
        print("Amazon default.isLoggedIn: \(AWSMobileClient.default().isLoggedIn)")
        print("Amazon default.currentUserState: \(AWSMobileClient.default().currentUserState)")
            
        if let currentAccessToken = AccessToken.current {
            print("Facebook AccessToken.current.isExpired: \(currentAccessToken.isExpired)")
            print("Facebook AccessToken.current.tokenString: \(currentAccessToken.tokenString)")
        } else {
            print("Facebook AccessToken.current: nil")
        }
        
        return AWSMobileClient.default().currentUserState == .signedIn
            && AccessToken.current != nil
            && AccessToken.current?.isExpired == false
    }
    
    func logout() {
        cognitoLoginManager.logout()
        facebookUserLoginManager.logout()
        AppStateHolder.instance.state = .needToLogin
    }
}
