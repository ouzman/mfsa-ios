//
//  LoginViewModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import Combine
import Amplify

final class LoginViewModel : ObservableObject {
    private let loginService: LoginService = LoginService.instance
    
    private var loginCancellable: Combine.Cancellable? {
        didSet { oldValue?.cancel() }
    }
    
    @Published var errorAlertDetails: ErrorAlertDetails? = nil
        
    deinit {
        loginCancellable?.cancel()
    }
    
    func facebookLogin() {
        loginCancellable = loginService.login(provider: .facebook)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink(receiveValue: { loginResult in
                switch loginResult {
                case .success:
                    AppState.instance.userState = .loggedIn
                    break
                case .failure(let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: error.provider.visibleName, details: error.description)
                    break
                }
            })
    }
}
