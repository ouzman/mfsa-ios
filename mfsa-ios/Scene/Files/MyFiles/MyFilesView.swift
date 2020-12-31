//
//  MyFilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import SwiftUI

struct MyFilesView: View {
    @ObservedObject var viewModel: MyFilesViewModel

    init() {
        self.viewModel = MyFilesViewModel()
    }
    
    var body: some View {
        let alertActive = Binding<Bool>(
            get: { self.viewModel.errorAlertDetails != nil },
            set: { if !$0 { self.viewModel.errorAlertDetails = nil } }
        )
        
        List {
            AddFileRow { url in viewModel.addFile(url: url) }
            ForEach(self.viewModel.fileList, id: \.self) { (file: RemoteFileModel) in
                FileRow(file: FileModel(id: file.key,
                                        name: file.fileName,
//                                         selectionAction: { file in print("selection \(file.name)")},
                                        downloadAction: { file in print("download \(file.name)") },
                                        shareAction: { file in print("share \(file.name)") },
                                        deleteAction: { file in print("delete \(file.name)") }))
            }
        }
        .onAppear(perform: { viewModel.retrieveFiles() })
        .alert(isPresented: alertActive, content: {
            Alert(title: Text(self.viewModel.errorAlertDetails!.title),
                  message: Text(self.viewModel.errorAlertDetails!.details),
                  dismissButton: .default(Text("OK")))
        })
    }
}

struct MyFilesView_Previews: PreviewProvider {
    static var previews: some View {
        MyFilesView()
    }
}
