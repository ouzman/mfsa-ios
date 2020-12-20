//
//  LoginViewModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    private let loginService: LoginService = LoginService.instance
    
    private var loginCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }
    
    @Published var errorAlertDetails: ErrorAlertDetails? = nil
        
    deinit {
        loginCancellable?.cancel()
    }
        
    func facebookLogin() {
        loginCancellable = loginService.facebookLogin()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink(receiveValue: { loginResult in
                switch loginResult {
                case .success:
                    AppStateHolder.instance.state = .loggedIn
                    break
                case .failure(let provider, let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: provider.visibleName, details: error.errorDescription ?? "Unknown error")
                    break
                }
            })
    }
}

struct ErrorAlertDetails: Error {
    let title: String
    let details: String
}
