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
            AddFileRow { url in print(url) }
            FolderRow(name: "Test Folder 1")
            FolderRow(name: "Test Folder 2")
        }
    }
}

struct MyFilesView_Previews: PreviewProvider {
    static var previews: some View {
        MyFilesView()
    }
}
