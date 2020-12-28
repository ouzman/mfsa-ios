//
//  AppStateService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 28.12.2020.
//

import Combine
import Amplify

class UserService {
    var cancellables = Set<AnyCancellable>()
    static let instance = UserService()
    
    func fetchUserState() -> AnyPublisher<UserState, Never> {
        return Amplify.Auth.fetchAuthSession()
            .resultPublisher
            .map({ session in
                if session.isSignedIn {
                    return .loggedIn
                } else {
                    return .needToLogin
                }
            })
            .replaceError(with: .needToLogin)
            .eraseToAnyPublisher()
    }
}
