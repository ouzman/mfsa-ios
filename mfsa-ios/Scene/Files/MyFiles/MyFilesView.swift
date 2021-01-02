//
//  MyFilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import SwiftUI

struct MyFilesView: View {
    @ObservedObject var viewModel: MyFilesViewModel
    
    @State var showShareAlertForFile: FileModel? = nil
    
    init() {
        self.viewModel = MyFilesViewModel()
    }
    
    var body: some View {
        let errorAlertActive = Binding<Bool>(
            get: { self.viewModel.errorAlertDetails != nil },
            set: { if !$0 { self.viewModel.errorAlertDetails = nil } }
        )
        let shareAlertActive = Binding<Bool>(
            get: { self.showShareAlertForFile != nil },
            set: { if !$0 { self.showShareAlertForFile = nil } }
        )
        
        List {
            AddFileRow { url in viewModel.addFile(url: url) }
            ForEach(self.viewModel.fileList, id: \.self) { (file: RemoteFileModel) in
                FileRow(file: FileModel(id: file.key,
                                        name: file.fileName,
                                        downloadAction: { file in self.viewModel.downloadFile(fileKey: file.id, fileName: file.name) },
                                        shareAction: { file in self.showShareAlertForFile = file },
                                        deleteAction: { file in self.viewModel.deleteFile(fileKey: file.id) }))
            }
        }
        .onAppear(perform: { viewModel.retrieveFiles() })
        .alert(isPresented: errorAlertActive, content: {
            Alert(title: Text(self.viewModel.errorAlertDetails!.title),
                  message: Text(self.viewModel.errorAlertDetails!.details),
                  dismissButton: .default(Text("OK")))
        })
        .alert(isPresented: shareAlertActive,
               TextAlert(title: "Share",
                         message: "Please add email address of any user that you want to share this file",
                         accept: "Share",
                         keyboardType: .emailAddress) { result in
                if let emailAddress = result,
                   let file = self.showShareAlertForFile {
                    self.viewModel.shareFile(fileKey: file.id, emailAddress: emailAddress)
                } else {
                    self.showShareAlertForFile = nil
                }
               })
    }
}

struct MyFilesView_Previews: PreviewProvider {
    static var previews: some View {
        MyFilesView()
    }
}
