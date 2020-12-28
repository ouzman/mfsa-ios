//
//  AppStateHolder.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import Combine

class AppState : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    static let instance = AppState()

    @Published var userState : UserState = .needToLogin
        
    private init() {
//        LoginService.instance.userLoggedIn()
//            .sink { loginResult in
//                switch loginResult {
//                case .success:
//                    self.state = .loggedIn
//                    break
//                case .failure( _, _):
//                    self.state = .needToLogin
//                    break
//                }
//            }
//            .store(in: &cancellables)
    }
}
