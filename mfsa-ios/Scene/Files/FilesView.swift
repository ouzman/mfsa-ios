//
//  FilesView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 13.12.2020.
//

import SwiftUI

struct FilesView: View {
    var body: some View {
        TabView {
            MyFilesView()
                .tabItem {
                    Image(systemName: "person")
                    Text("My Files")
                }
            
            SharedFilesView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Shared Files")
                }
        }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
    }
}

struct FilesView_Previews: PreviewProvider {
    static var previews: some View {
        FilesView()
    }
}
