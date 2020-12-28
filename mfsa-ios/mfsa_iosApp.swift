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
            UserService.instance.fetchUserState()
                .sink { userState in
                    AppState.instance.userState = userState
                }
                .store(in: &cancellables)
            
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(AppState.instance)
        }
    }
}
