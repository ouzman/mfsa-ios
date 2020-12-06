//
//  mfsa_iosApp.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 6.12.2020.
//

import SwiftUI
import AWSCore
import AWSCognito
import FBSDKCoreKit
import UIKit

@main
struct mfsa_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .EUWest1, identityPoolId: "eu-west-1:d0f736f6-e27d-4c36-aa6c-6095997c889c")
        let configuration = AWSServiceConfiguration(region: .EUWest1, credentialsProvider: credentialsProvider)

        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                            ApplicationDelegate.shared.application(
                                   UIApplication.shared,
                                   open: url,
                                   sourceApplication: nil,
                                   annotation: [UIApplication.OpenURLOptionsKey.annotation]
                               )
                })
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
          
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
