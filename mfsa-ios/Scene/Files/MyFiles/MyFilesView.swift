//
//  MyFilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import SwiftUI

struct MyFilesView: View {
    @ObservedObject var viewModel: MyFilesViewModel
    
    init(viewModel: MyFilesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let alertActive = Binding<Bool>(
            get: { self.viewModel.errorAlertDetails != nil },
            set: { if !$0 { self.viewModel.errorAlertDetails = nil } }
        )
        
        List {
            Group {
                AddFileRow { url in viewModel.addFile(url: url) }
                FolderRow(name: "Test Folder 1")
                FolderRow(name: "Test Folder 2")
            }
            Group {
                FileRow(file: FileModel(name: "File 1",
                                        selectionAction: { print("selection \($0.name)")},
                                        downloadAction: { print("download \($0.name)") },
                                        shareAction: { print("share \($0.name)") },
                                        deleteAction: { print("delete \($0.name)") }))
                FileRow(file: FileModel(name: "File 2",
                                        selectionAction: { print("selection \($0.name)")},
                                        downloadAction: { print("download \($0.name)") },
                                        shareAction: { print("share \($0.name)") },
                                        deleteAction: { print("delete \($0.name)") }))
            }
        }
        .alert(isPresented: alertActive, content: {
            Alert(title: Text(self.viewModel.errorAlertDetails!.title),
                  message: Text(self.viewModel.errorAlertDetails!.details),
                  dismissButton: .default(Text("OK")))
        })
    }
}

struct MyFilesView_Previews: PreviewProvider {
    static var previews: some View {
        MyFilesView(viewModel: MyFilesViewModel())
    }
}
