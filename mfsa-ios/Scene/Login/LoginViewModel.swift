//
//  LoginViewModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import SwiftUI
import Combine
import FBSDKCoreKit
import AWSMobileClient

final class LoginViewModel: ObservableObject {
    private let facebookUserLoginManager = FacebookUserLoginManager()
    private let cognitoLoginManager = CognitoLoginManager()
    
    private var loginCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }
    
    @Published var errorAlertDetails: ErrorAlertDetails? = nil
        
    deinit {
        loginCancellable?.cancel()
    }
    
    func facebookLogin() {
        loginCancellable = facebookUserLoginManager.login()
            .mapErrorToAlertDetails()
            .flatMap { self.cognitoLoginManager.federatedSignIn(with: $0.tokenString).mapErrorToAlertDetails() }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { (completion: (Subscribers.Completion<ErrorAlertDetails>)) in
                if case .failure(let error) = completion {
                    self.errorAlertDetails = error
                }
            }, receiveValue: { (_) in
                AppStateHolder.instance.state = .loggedIn
            })
    }
}

struct ErrorAlertDetails: Error {
    let title: String
    let details: String
}

extension Publisher where Failure == CognitoLoginError {
    func mapErrorToAlertDetails() -> AnyPublisher<Self.Output, ErrorAlertDetails> {
        self
            .mapError { (error: Self.Failure) -> ErrorAlertDetails in
                ErrorAlertDetails(title: "Cognito Error", details: error.errorDescription!)
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Failure == FacebookLoginError {
    func mapErrorToAlertDetails() -> AnyPublisher<Self.Output, ErrorAlertDetails> {
        self
            .mapError { (error: Self.Failure) -> ErrorAlertDetails in
                ErrorAlertDetails(title: "Facebook Error", details: error.errorDescription!)
            }
            .eraseToAnyPublisher()
    }
}
