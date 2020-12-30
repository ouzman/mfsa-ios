//
//  RemoteFileService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

import Foundation
import Amplify
import Combine

final class RemoteFileService {
    static let instance = RemoteFileService()
    
    private init() { }
    
    func uploadFile(url: URL) -> (resultPublisher: AnyPublisher<Void, RemoteFileError>, progressPublisher: AnyPublisher<Progress, Never>) {
        let operation = Amplify.Storage.uploadFile(key: generateFileKey(url),
                                                   local: url,
                                                   options: generateOptions(url))
        
        let resultPublisher: AnyPublisher<Void, RemoteFileError> = operation
            .resultPublisher
            .map { _ in Void() }
            .mapError { RemoteFileError.storageError(error: $0) }
            .eraseToAnyPublisher()
        
        let progressPublisher = operation.progressPublisher
        
        return (resultPublisher, progressPublisher)
    }
    
    private func generateFileKey(_ url: URL) -> String {
        return "\(UUID().uuidString)-\(url.lastPathComponent)"
    }
    
    private func generateOptions(_ url: URL) -> StorageUploadFileRequest.Options {
        return StorageUploadFileRequest.Options.init(accessLevel: .protected,
                                                     metadata: ["original-file-name": url.lastPathComponent])
    }
}
