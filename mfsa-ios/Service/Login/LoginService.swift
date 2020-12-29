//
//  LoginService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import Combine
import Amplify

class LoginService {
    static let instance = LoginService()
    
    private init() { }
    
    func login(provider: LoginProvider) -> AnyPublisher<LoginResult, Never> {
        return Amplify.Auth.signInWithWebUI(for: provider.authProvider, presentationAnchor: UIApplication.shared.firstWindow!).resultPublisher
            .flatMap { (result: AuthSignInResult) -> Future<LoginResult, AuthError> in
                return Future<LoginResult, AuthError> { promise in
                    if result.isSignedIn {
                        promise(.success(.success))
                    } else {
                        promise(.failure(AuthError.invalidState("Next step should be: \(result.nextStep)", "Unknown", nil)))
                    }
                }
            }
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
