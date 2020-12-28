//
//  LoginService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import Combine
import Amplify

class LoginService {
    private var cancellables = Set<AnyCancellable>()

    static let instance = LoginService()

    private init() { }
    
    func login(provider: LoginProvider) -> AnyPublisher<LoginResult, Never> {
        return Amplify.Auth.signInWithWebUI(for: provider.authProvider,
                                            presentationAnchor: UIApplication.shared.firstWindow!)
            .resultPublisher
            .map { _ in LoginResult.success }
            .catch({ (authError: AuthError) -> Just<LoginResult> in
                print(authError.debugDescription)
                return Just(LoginResult.failure(error: LoginError(provider: provider, description: authError.errorDescription)))
            })
            .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Never> {
        Amplify.Auth.signOut()
            .resultPublisher
            .catch({ (authError: AuthError) -> Just<Void> in
                print(authError.debugDescription)
                return Just(Void())
            })
            .eraseToAnyPublisher()
    }
}

extension LoginProvider {
    var authProvider: AuthProvider {
        get {
            switch self {
            case .facebook:
                return .facebook
            }
        }
    }
}
