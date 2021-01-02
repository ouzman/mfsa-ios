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
    private static let REGION = "eu-west-1"
    static let instance = RemoteFileService()
    
    private var cancellables = Set<AnyCancellable>()
    
    
    private init() { }
    
    func uploadFile(url: URL) -> (resultPublisher: AnyPublisher<Void, RemoteFileError>, progressPublisher: AnyPublisher<Progress, Never>) {
        let operation = Amplify.Storage.uploadFile(key: generateFileKey(url),
                                                   local: url,
                                                   options: generateUploadOptions(url))
        
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
                    .zip(UserService.instance.getCurrentUserSub().mapError { RemoteFileError.userError(error: $0) })
                    .map { (metadata: [String:String], currentUserSub: String) -> RemoteFileModel in
                        return RemoteFileModel(key: item.key,
                                               nativeFileKey: "protected/\(Self.REGION):\(currentUserSub)/\(item.key)",
                                               fileName: metadata[Self.ORIGINAL_FILE_NAME_METADATA_KEY] ?? "",
                                               owner: nil)
                    }
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
    
    func downloadFile(fileKey: String, localDirectory: URL, fileName: String) -> AnyPublisher<Void, RemoteFileError> {
        let _ = localDirectory.startAccessingSecurityScopedResource()
        return Amplify.Storage.downloadFile(key: fileKey,
                                            local: localDirectory.appendingPathComponent(fileName),
                                            options: StorageDownloadFileRequest.Options.init(accessLevel: .protected))
            .resultPublisher
            .map { _ in
                let _ = localDirectory.stopAccessingSecurityScopedResource()
                return
            }
            .mapError { RemoteFileError.storageError(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func shareFile(fileKey: String, emailAddress: String) -> AnyPublisher<Void, RemoteFileError> {
        return Amplify.API.put(request: RESTRequest.init(apiName: "MFSA-Share-API", path: "/file-resource/\(fileKey)/identity", body: emailAddress.data(using: .utf8)))
            .resultPublisher
            .map { (_: Data) -> Void in Void() }
            .mapError { RemoteFileError.apiError(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func listSharedFiles() -> AnyPublisher<[RemoteFileModel], RemoteFileError> {
        Amplify.API.get(request: RESTRequest.init(apiName: "MFSA-Share-API", path: "/file-resource"))
            .resultPublisher
            .mapError { RemoteFileError.apiError(error: $0) }
            .flatMap { (data: Data) -> Future<[SharedFileResourceModel], RemoteFileError> in
                return Future<[SharedFileResourceModel], RemoteFileError>() { promise in
                    do {
                        promise(.success(try JSONDecoder().decode([SharedFileResourceModel].self, from: data)))
                    } catch {
                        promise(.failure(RemoteFileError.sharedFileDecodeError(error: error)))
                    }
                }
            }
            .map { sharedFiles in sharedFiles.map { RemoteFileModel(key: $0.key, nativeFileKey: $0.nativeKey, fileName: $0.fileName, owner: $0.owner) } }
            .eraseToAnyPublisher()
    }
    
    func deleteFileShare(fileKey: String) -> AnyPublisher<Void, RemoteFileError> {
        return Amplify.API.delete(request: RESTRequest.init(apiName: "MFSA-Share-API", path: "/file-resource/\(fileKey)"))
            .resultPublisher
            .map { (_: Data) -> Void in Void() }
            .mapError { RemoteFileError.apiError(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func downloadSharedFile(fileKey: String, owner: String, localDirectory: URL, fileName: String) -> AnyPublisher<Void, RemoteFileError> {
        let _ = localDirectory.startAccessingSecurityScopedResource()
        return Amplify.Storage.downloadFile(key: fileKey,
                                            local: localDirectory.appendingPathComponent(fileName),
                                            options: StorageDownloadFileRequest.Options.init(accessLevel: .protected, targetIdentityId: owner))
            .resultPublisher
            .map { _ in
                let _ = localDirectory.stopAccessingSecurityScopedResource()
                return
            }
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
    
    private func generateUploadOptions(_ url: URL) -> StorageUploadFileRequest.Options {
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
