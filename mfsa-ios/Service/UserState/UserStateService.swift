//
//  AppStateService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 28.12.2020.
//

import Combine
import Amplify

class UserService {
    static let instance = UserService()
    
    private init() { }
    
    func fetchUserState() -> AnyPublisher<UserState, Never> {
        return Amplify.Auth.fetchAuthSession()
            .resultPublisher
            .map({ _ in UserState.loggedIn })
            .catch { (authError: AuthError) in
                return Just(UserState.needToLogin)
            }
            .eraseToAnyPublisher()
    }
}
