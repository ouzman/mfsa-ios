//
//  FilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 13.12.2020.
//

import SwiftUI

struct FilesView: View {
    @State private var tabSelection: FilesTabs = .myFiles
    
    var body: some View {
        TabView(selection: $tabSelection) {
            self.myFilesView
                .tabItem {
                    Image(systemName: "person")
                    Text(FilesTabs.myFiles.getTitle())
                }
                .tag(FilesTabs.myFiles)
            
            self.sharedFilesView
                .tabItem {
                    Image(systemName: "person.2")
                    Text(FilesTabs.sharedWithMe.getTitle())
                }
                .tag(FilesTabs.sharedWithMe)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: LogoutButton())
        .navigationTitle(self.tabSelection.getTitle())
    }
    
    let myFilesView = MyFilesView()
    let sharedFilesView = SharedFilesView()
}

enum FilesTabs {
    case myFiles
    case sharedWithMe
    
    func getTitle() -> String {
        switch self {
        case .myFiles:
            return "My Files"
        case .sharedWithMe:
            return "Shared With Me"
        }
    }
}

struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
