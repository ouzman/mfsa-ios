//
//  MyFilesViewModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

import Combine
import Foundation

final class MyFilesViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var delegate = FileChooser.PickDownloadFileLocationDelegate()

    @Published var errorAlertDetails: ErrorAlertDetails? = nil
    @Published var fileList: [RemoteFileModel] = []
    
    func addFile(url: URL) {
        let (resultPublisher, progressPublisher) = RemoteFileService.instance.uploadFile(url: url)
        
        resultPublisher
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorAlertDetails = ErrorAlertDetails(title: "Add File Error", details: error.description)
                        break
                    }
                },
                receiveValue: {
                    self.errorAlertDetails = ErrorAlertDetails(title: "Add File", details: "Upload completed")
                    self.retrieveFiles()
                })
            .store(in: &cancellables)
        
        progressPublisher
            .sink(receiveValue: { print($0) })
            .store(in: &cancellables)
    }
    
    func retrieveFiles() {
        RemoteFileService.instance.listFiles()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: "Retrieve Files Error", details: error.description)
                    break
                }
            } receiveValue: { (remoteFiles) in
                self.fileList = remoteFiles
            }
            .store(in: &cancellables)
    }
    
    func deleteFile(fileKey: String) {
        RemoteFileService.instance.deleteFile(fileKey: fileKey)
            .flatMap({ RemoteFileService.instance.deleteFileShare(fileKey: fileKey) })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: "File Delete Error", details: error.description)
                    break
                }
            } receiveValue: {
                self.errorAlertDetails = ErrorAlertDetails(title: "Delete File", details: "Successfully deleted")
                self.retrieveFiles()
            }
            .store(in: &cancellables)
    }
    
    func downloadFile(fileKey: String, fileName: String) {
        FileChooser.instance.openDownloadFileLocationPicker(delegate: self.delegate)
            .flatMap { (url: URL) -> AnyPublisher<Void, RemoteFileError> in
                return RemoteFileService.instance.downloadFile(fileKey: fileKey, localDirectory: url, fileName: fileName)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: "File Download Error", details: error.description)
                    break
                }
            } receiveValue: {
                self.errorAlertDetails = ErrorAlertDetails(title: "Download File", details: "Download completed")
            }
            .store(in: &cancellables)
    }
    
    func shareFile(fileKey: String, emailAddress: String) {
        RemoteFileService.instance.shareFile(fileKey: fileKey, emailAddress: emailAddress)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: "File Share Error", details: error.description)
                    break
                }
            } receiveValue: {
                self.errorAlertDetails = ErrorAlertDetails(title: "Share File", details: "File successfully shared")
            }
            .store(in: &cancellables) 
    }
}
