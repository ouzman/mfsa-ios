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
}
