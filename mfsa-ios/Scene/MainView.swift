//
//  MainView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 13.12.2020.
//

import SwiftUI
import AWSMobileClient

struct MainView: View {

    @EnvironmentObject var stateHolder: AppStateHolder
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Mobile File Sharing App")
                NavigationLink(destination: LoginView(viewModel: LoginViewModel()),
                               tag: AppState.needToLogin,
                               selection: Binding<AppState?>($stateHolder.state)) {
                    EmptyView()
                }
                NavigationLink(destination: FilesView(),
                               tag: AppState.loggedIn,
                               selection: Binding<AppState?>($stateHolder.state)) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
        .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
