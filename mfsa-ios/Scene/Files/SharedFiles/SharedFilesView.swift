//
//  SharedFilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import SwiftUI

struct SharedFilesView: View {
    @ObservedObject var viewModel: SharedFilesViewModel
    
    init() {
        self.viewModel = SharedFilesViewModel()
    }
    
    var body: some View {
        let errorAlertActive = Binding<Bool>(
            get: { self.viewModel.errorAlertDetails != nil },
            set: { if !$0 { self.viewModel.errorAlertDetails = nil } }
        )

        List {
            ForEach(self.viewModel.sharedFileList, id: \.self) { (remoteFile: RemoteFileModel) in
                FileRow(file: FileModel(id: remoteFile.key,
                                        name: remoteFile.fileName,
                                        downloadAction: { file in self.viewModel.downloadSharedFile(fileKey: remoteFile.key, owner: remoteFile.owner, fileName: remoteFile.fileName) }))
            }
        }
        .onAppear { self.viewModel.retrieveSharedFiles() }
        .alert(isPresented: errorAlertActive, content: {
            Alert(title: Text(self.viewModel.errorAlertDetails!.title),
                  message: Text(self.viewModel.errorAlertDetails!.details),
                  dismissButton: .default(Text("OK")))
        })
    }
}

struct SharedFilesView_Previews: PreviewProvider {
    static var previews: some View {
        SharedFilesView()
    }
}
