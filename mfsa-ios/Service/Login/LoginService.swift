//
//  LoginService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

import Combine
import Foundation
import Amplify

class LoginService {
    private var cancellables = Set<AnyCancellable>()

    static let instance = LoginService()

    private init() { }
    
    func facebookLogin() -> AnyPublisher<LoginResult, Never> {
        return Amplify.Auth.signInWithWebUI(for: .facebook,
                                     presentationAnchor: getWindow()!)
            .resultPublisher
            .map { _ in LoginResult.success }
            .catch({ (authError: AuthError) -> Just<LoginResult> in
                print(authError.debugDescription)
                return Just(LoginResult.failure(provider: .cognito, error: authError as Error)) // FIXME: Error is not the right type
            })
            .eraseToAnyPublisher()
    }
    
    private func getWindow() -> UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    func userLoggedIn() -> AnyPublisher<LoginResult, Never> { // TODO: try to change LoginResult
        return Amplify.Auth.fetchAuthSession()
            .resultPublisher
            .map({ _ in LoginResult.success })
            .catch { (authError: AuthError) in
                return Just(LoginResult.failure(provider: .cognito, error: authError as Error)) // FIXME: Error is not the right type
            }
            .eraseToAnyPublisher()
    }
    
    func logout() {
        Amplify.Auth.signOut()
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print(authError.errorDescription)
                }
            } receiveValue: { _ in
                AppStateHolder.instance.state = .needToLogin
            }
            .store(in: &cancellables)
    }
}
