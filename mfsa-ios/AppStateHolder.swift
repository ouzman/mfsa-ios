//
//  AppStateHolder.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import Combine

class AppStateHolder : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    static let instance = AppStateHolder()

    @Published var state : AppState = .needToLogin
        
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

enum AppState {
    case needToLogin
    case loggedIn
}
