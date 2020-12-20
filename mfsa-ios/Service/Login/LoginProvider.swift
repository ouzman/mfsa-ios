//
//  LoginProvider.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 21.12.2020.
//

enum LoginProvider {
    case facebook
    case cognito
    
    var visibleName: String {
        get {
            switch self {
            case .facebook:
                return "Facebook"
            case .cognito:
                return "Amazon Cognito"
            }
        }
    }
}
