//
//  FileRow.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import SwiftUI

struct FolderRow: View {
    let name: String
    
    var body: some View {
        HStack {
            Image(systemName: "folder")
            Text(name)
        }
    }
}

struct FolderRow_Previews: PreviewProvider {
    static var previews: some View {
        FolderRow(name: "Test Folder")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
