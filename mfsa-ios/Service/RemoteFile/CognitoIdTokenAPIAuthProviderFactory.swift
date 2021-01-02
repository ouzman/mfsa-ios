//
//  CognitoIdTokenAPIAuthProviderFactory.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 1.01.2021.
//

import Amplify
import Foundation
import AWSPluginsCore

class CognitoIdTokenAPIAuthProviderFactory: APIAuthProviderFactory {
  let myAuthProvider = IdTokenAuthProvider()

  override func oidcAuthProvider() -> AmplifyOIDCAuthProvider? {
      return myAuthProvider
  }
}

class IdTokenAuthProvider : AmplifyOIDCAuthProvider {
    func getLatestAuthToken() -> Result<String, Error> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<String, Error> = .failure(AuthError.unknown("Could not retrieve Cognito token"))
        Amplify.Auth.fetchAuthSession { (event) in
            defer {
                semaphore.signal()
            }
            switch event {
            case .success(let session):
                if let cognitoTokenResult = (session as? AuthCognitoTokensProvider)?.getCognitoTokens() {
                    switch cognitoTokenResult {
                    case .success(let tokens):
                        result = .success(tokens.idToken)
                    case .failure(let error):
                        result = .failure(error)
                    }
                }
            case .failure(let error):
                result = .failure(error)
            }
        }
        semaphore.wait()
        return result
    }
}
