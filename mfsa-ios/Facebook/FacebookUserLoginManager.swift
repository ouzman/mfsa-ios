//
//  FacebookUserLoginManager.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import Combine
import FBSDKLoginKit

final class FacebookUserLoginManager {
    private let loginManager = LoginManager()
    
    func login() -> Future<FBSDKCoreKit.AccessToken, FacebookLoginError> {
        return Future<FBSDKCoreKit.AccessToken, FacebookLoginError> { (promise) in

            self.loginManager.logIn(permissions: [.email], viewController: nil) { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    promise(.failure(FacebookLoginError.wrapped(error)))
                    return
                case .cancelled:
                    promise(.failure(FacebookLoginError.cancelled))
                    return
                case .success(_, let declinedPermissions, let accessToken):
                    if declinedPermissions.contains(FBSDKCoreKit.Permission.email) {
                        promise(.failure(FacebookLoginError.unsufficientPermission))
                        return
                    }
                    
                    GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, email"]).start { (connection, result, error) in
                        if let error = error {
                            promise(.failure(FacebookLoginError.wrapped(error)))
                        } else {
                            promise(.success(accessToken))
                        }
                    }
                }
            }
        }
    }
}
