//
//  mfsa_iosApp.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 6.12.2020.
//

import SwiftUI
import AWSMobileClient
import FBSDKLoginKit

@main
struct mfsa_iosApp: App {
    init() {
        AWSMobileClient.default().initialize { (userState, error) in
             if let userState = userState {
                 print("UserState: \(userState.rawValue)")
             } else if let error = error {
                 print("error: \(error.localizedDescription)")
             }
         }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(AppStateHolder.instance)
        }
    }
}
