//
//  MyFilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import SwiftUI

struct MyFilesView: View {
    var body: some View {
        List {
            Group {
                AddFileRow { url in print(url) }
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
    }
}

struct MyFilesView_Previews: PreviewProvider {
    static var previews: some View {
        MyFilesView()
    }
}
