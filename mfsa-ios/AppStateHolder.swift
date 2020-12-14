//
//  AppStateHolder.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import Foundation

class AppStateHolder : ObservableObject {
    static let instance = AppStateHolder()
    
    @Published var state : AppState
        
    private init() {
        self.state = .needToLogin
    }
}

enum AppState {
    case needToLogin
    case loggedIn
}
