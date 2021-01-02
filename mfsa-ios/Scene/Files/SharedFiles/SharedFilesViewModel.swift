//
//  MyFilesViewModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

import Combine
import Foundation

final class SharedFilesViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var delegate = FileChooser.PickDownloadFileLocationDelegate()
    
    @Published var errorAlertDetails: ErrorAlertDetails? = nil
    @Published var sharedFileList: [RemoteFileModel] = []

    func retrieveSharedFiles() {
        RemoteFileService.instance.listSharedFiles()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: "Retrieve Shared Files Error", details: error.description)
                    break
                }
            } receiveValue: { (remoteFiles: [RemoteFileModel]) in
                self.sharedFileList = remoteFiles
            }
            .store(in: &cancellables)
    }
    
    func downloadSharedFile(fileKey: String, owner: String?, fileName: String) {
        guard let owner = owner else {
            self.errorAlertDetails = ErrorAlertDetails(title: "Shared File Download Error", details: "File ownership is unknown")
            return
        }
        
        FileChooser.instance.openDownloadFileLocationPicker(delegate: self.delegate)
            .flatMap { (url: URL) -> AnyPublisher<Void, RemoteFileError> in
                return RemoteFileService.instance.downloadSharedFile(fileKey: fileKey, owner: owner, localDirectory: url, fileName: fileName)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorAlertDetails = ErrorAlertDetails(title: "Shared File Download Error", details: error.description)
                    break
                }
            } receiveValue: {
                self.errorAlertDetails = ErrorAlertDetails(title: "Download File", details: "Download completed")
            }
            .store(in: &cancellables)
    }

}
