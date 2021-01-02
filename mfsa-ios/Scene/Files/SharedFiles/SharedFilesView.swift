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
        List {
            ForEach(self.viewModel.sharedFileList, id: \.self) { (file: RemoteFileModel) in
                FileRow(file: FileModel(id: file.key,
                                        name: file.fileName,
                                        downloadAction: { file in print(file) }))
            }
        }
        .onAppear { self.viewModel.retrieveSharedFiles() }
    }
}

struct SharedFilesView_Previews: PreviewProvider {
    static var previews: some View {
        SharedFilesView()
    }
}
