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
}
