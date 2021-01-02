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
    case getEscapeHatchError(error: Error)
    case buildMetadataRequestError
    case retrieveMetadataError(error: Error)
    case retrieveMetadataUnknownError
    case userError(error: UserError)
    case apiError(error: APIError)
    case testError(error: Error)
    case testUnknownError

    var description: String {
        get {
            switch self {
            case .storageError(let error):
                return error.errorDescription
            case .getEscapeHatchError(let error):
                return "Couldn't get escape hatch: \(error.localizedDescription)"
            case .buildMetadataRequestError:
                return "Metadata request couldn't be build"
            case .retrieveMetadataError(let error):
                return error.localizedDescription
            case .retrieveMetadataUnknownError:
                return "Unknown error occurred when retrieving metadata"
            case .userError(let error):
                return error.description
            case .apiError(let error):
                return error.errorDescription
            case .testError(let error):
                return error.localizedDescription
            case .testUnknownError:
                return "Unknown error occurred when testing"
            }
        }
    }
}
