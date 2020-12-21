//
//  mfsa_iosApp.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 6.12.2020.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import Combine

@main
struct mfsa_iosApp: App {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
            LoginService.instance.userLoggedIn()
                .sink { loginResult in
                    switch loginResult {
                    case .success:
                        AppStateHolder.instance.state = .loggedIn
                        break
                    case .failure(_, _):
                        AppStateHolder.instance.state = .needToLogin
                        break
                    }
                }
                .store(in: &cancellables)
            
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(AppStateHolder.instance)
        }
    }
}
