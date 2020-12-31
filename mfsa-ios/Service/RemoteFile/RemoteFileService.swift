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
    private static let ORIGINAL_FILE_NAME_METADATA_KEY = "original-file-name"
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
            .flatMap { (item: StorageListResult.Item) -> AnyPublisher<RemoteFileModel, RemoteFileError> in
                self.getMetadata(from: item.key)
                    .map { (metadata: [String:String]) -> RemoteFileModel in
                        return RemoteFileModel(key: item.key,
                                               fileName: metadata[Self.ORIGINAL_FILE_NAME_METADATA_KEY] ?? "",
                                               metadata: metadata) }
                    .eraseToAnyPublisher()
            }
            .collect()
            .sort { $0.fileName < $1.fileName }
            .eraseToAnyPublisher()
    }
    
    func deleteFile(fileKey: String) -> AnyPublisher<Void, RemoteFileError> {
        return Amplify.Storage.remove(key: fileKey, options: StorageRemoveRequest.Options.init(accessLevel: .protected))
            .resultPublisher
            .map { (_: String) -> Void in }
            .mapError { RemoteFileError.storageError(error: $0) }
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
    
    private func getNativeFileKey(fileKey: String) -> AnyPublisher<String, RemoteFileError> {
        return UserService.instance.getCurrentUserSub()
            .mapError { RemoteFileError.userError(error: $0) }
            .map { (sub) in "protected/\(sub)/\(fileKey)" }
            .eraseToAnyPublisher()
    }
    
    private func generateMetadataRequest(fileKey: String, bucketName: String) -> AnyPublisher<AWSS3HeadObjectRequest, RemoteFileError> {
        self.getNativeFileKey(fileKey: fileKey)
            .flatMap { (nativeFileKey) -> Future<AWSS3HeadObjectRequest, RemoteFileError> in
                return Future<AWSS3HeadObjectRequest, RemoteFileError>() { promise in
                    if let request = AWSS3HeadObjectRequest() {
                        request.bucket = bucketName
                        request.key = nativeFileKey
                        promise(.success(request))
                    } else {
                        promise(.failure(RemoteFileError.buildMetadataRequestError))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func generateFileKey(_ url: URL) -> String {
        return "\(UUID().uuidString)-\(url.lastPathComponent)"
    }
    
    private func generateOptions(_ url: URL) -> StorageUploadFileRequest.Options {
        return StorageUploadFileRequest.Options.init(accessLevel: .protected,
                                                     metadata: [Self.ORIGINAL_FILE_NAME_METADATA_KEY: url.lastPathComponent])
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
