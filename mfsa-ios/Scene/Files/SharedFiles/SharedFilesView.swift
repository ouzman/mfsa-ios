//
//  SharedFilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import SwiftUI

struct SharedFilesView: View {
    var body: some View {
        List {
            FileRow(file: FileModel(id: "id",
                                    name: "Shared File 1",
                                    downloadAction: { print("download \($0.name)") }))
            FileRow(file: FileModel(id: "id",
                                    name: "Shared File 2",
                                    downloadAction: { print("download \($0.name)") }))
        }
    }
}

struct SharedFilesView_Previews: PreviewProvider {
    static var previews: some View {
        SharedFilesView()
    }
}
