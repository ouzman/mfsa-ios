//
//  RemoteFileService.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

import Foundation
import Amplify
import Combine
import AmplifyPlugins
import AWSS3

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
    
    func listFiles() -> AnyPublisher<[RemoteFileModel], RemoteFileError> {
        
        return Amplify.Storage.list(options: StorageListRequest.Options(accessLevel: .protected))
            .resultPublisher
            .flatMap { (result: StorageListResult) -> AnyPublisher<StorageListResult.Item, Never> in
                return result.items.publisher
                    .eraseToAnyPublisher()
            }
            .mapError { RemoteFileError.storageError(error: $0) }
            // .map { RemoteFileModel (key: $0.key, fileName: $0.key, metadata: [:]) } // FIXME
            .map { (item: StorageListResult.Item) in
                let startIndex = item.key.index(item.key.startIndex, offsetBy: 37)
                let endIndex = item.key.endIndex
                let temporaryFileName = item.key[startIndex..<endIndex]
                return RemoteFileModel(key: item.key, fileName: String(temporaryFileName), metadata: [:]) // FIXME
            }
//            .flatMap { (item: StorageListResult.Item) -> AnyPublisher<RemoteFileModel, RemoteFileError> in
//                self.getMetadata(from: item.key)
//                    .map { (metadata: [String:String]) -> RemoteFileModel in RemoteFileModel(key: item.key, metadata: metadata) }
//                    .eraseToAnyPublisher()
//            }
            .collect()
            .sort { $0.fileName < $1.fileName }
            .eraseToAnyPublisher()
    }
    
    private func getMetadata(from key: String) -> AnyPublisher<[String:String], RemoteFileError> {
        return getEscapeHatch()
            .zip(generateMetadataRequest(fileKey: key, bucketName: "mfsa-files"))
            .flatMap { (s3: AWSS3, request: AWSS3HeadObjectRequest) -> Future<AWSS3HeadObjectOutput, RemoteFileError> in
                return Future<AWSS3HeadObjectOutput, RemoteFileError>() {promise in
                    s3.headObject(request).continueWith { (task: AWSTask<AWSS3HeadObjectOutput>) -> Void in
                        if let result = task.result {
                            promise(.success(result))
                        } else if let error = task.error {
                            promise(.failure(RemoteFileError.retrieveMetadataError(error: error)))
                        } else {
                            promise(.failure(RemoteFileError.retrieveMetadataUnknownError))
                        }
                    }
                }
            }
            .map { $0.metadata ?? [:] }
            .eraseToAnyPublisher()
    }
    
    private func generateMetadataRequest(fileKey: String, bucketName: String) -> Future<AWSS3HeadObjectRequest, RemoteFileError> {
        return Future<AWSS3HeadObjectRequest, RemoteFileError>() { promise in
            if let request = AWSS3HeadObjectRequest() {
                request.bucket = bucketName
                request.key = fileKey
                promise(.success(request))
            } else {
                promise(.failure(RemoteFileError.buildMetadataRequestError))
            }
        }
    }
    
    private func generateFileKey(_ url: URL) -> String {
        return "\(UUID().uuidString)-\(url.lastPathComponent)"
    }
    
    private func generateOptions(_ url: URL) -> StorageUploadFileRequest.Options {
        return StorageUploadFileRequest.Options.init(accessLevel: .protected,
                                                     metadata: ["original-file-name": url.lastPathComponent])
    }
    
    private func getEscapeHatch() -> Future<AWSS3, RemoteFileError>{
        return Future<AWSS3, RemoteFileError>() { promise in
            do {
                let plugin = try Amplify.Storage.getPlugin(for: "awsS3StoragePlugin") as! AWSS3StoragePlugin
                promise(.success(plugin.getEscapeHatch()))
            } catch {
                promise(.failure(RemoteFileError.getEscapeHatchError(error: error)))
            }
        }
    }
}
