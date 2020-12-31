//
//  FileRow.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 20.12.2020.
//

import SwiftUI

struct FileRow: View {
    let file: FileModel
    
    var body: some View {
        if let selectionAction = self.file.selectionAction {
            Button(action: { selectionAction(self.file) }, label: { rowContent })
        } else {
            rowContent
        }
    }
    
    var rowContent: some View {
        HStack {
            Image(systemName: "doc")
            Text(self.file.name)
                .lineLimit(1)
            Spacer()
            if let downloadAction = self.file.downloadAction {
                Button(action: { downloadAction(self.file) }) {
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)
            }
            if let shareAction = self.file.shareAction {
                Button(action: { shareAction(self.file) }) {
                    Image(systemName: "person.badge.plus")
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)
            }
            if let deleteAction = self.file.deleteAction {
                Button(action: { deleteAction(self.file) }) {
                    Image(systemName: "trash")
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)
            }
        }
    }
}

struct FileRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FileRow(file: FileModel(id: "id",
                                    name: "File has just name",
                                    selectionAction: { _ in }))
                .previewLayout(.sizeThatFits)
                .padding()
            
            FileRow(file: FileModel(id: "id",
                                    name: "File user can download",
                                    selectionAction: { _ in },
                                    downloadAction: { _ in print("download") }))
                .previewLayout(.sizeThatFits)
                .padding()
            
            FileRow(file: FileModel(id: "id",
                                    name: "File user can download and share",
                                    selectionAction: { _ in },
                                    downloadAction: { _ in print("download action") },
                                    shareAction: { _ in print("share action") }))
                .previewLayout(.sizeThatFits)
                .padding()
            
            FileRow(file: FileModel(id: "id",
                                    name: "File user can download, share and delete",
                                    selectionAction: { _ in },
                                    downloadAction: { _ in print("download action") },
                                    shareAction: { _ in print("share action") },
                                    deleteAction: { _ in print("delete action") }))
                .previewLayout(.sizeThatFits)
                .padding()
            
        }
    }
}

struct FileModel: Identifiable {
    let id: String
    let name: String
    let selectionAction: ((FileModel) -> Void)?
    let downloadAction: ((FileModel) -> Void)?
    let shareAction: ((FileModel) -> Void)?
    let deleteAction: ((FileModel) -> Void)?
    
    init(id: String,
         name: String,
         selectionAction: ((FileModel) -> Void)? = nil,
         downloadAction: ((FileModel) -> Void)? = nil,
         shareAction: ((FileModel) -> Void)? = nil,
         deleteAction: ((FileModel) -> Void)? = nil
    ) {
        self.id = id
        self.name = name
        self.selectionAction = selectionAction
        self.downloadAction = downloadAction
        self.shareAction = shareAction
        self.deleteAction = deleteAction
    }
}
