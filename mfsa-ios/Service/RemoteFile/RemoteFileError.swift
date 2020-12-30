//
//  RemoteFileError.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

import Foundation
import Amplify

enum RemoteFileError : Error {
    case storageError(error: StorageError)
    
    var description: String {
        get {
            switch self {
            case .storageError(let error):
                return error.errorDescription
            }
        }
    }
}
