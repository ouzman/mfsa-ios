//
//  MainView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 13.12.2020.
//

import SwiftUI
import AWSMobileClient

struct MainView: View {

    @EnvironmentObject var state: AppState
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Mobile File Sharing App")
                NavigationLink(destination: LoginView(viewModel: LoginViewModel()),
                               tag: UserState.needToLogin,
                               selection: Binding<UserState?>($state.userState)) {
                    EmptyView()
                }
                NavigationLink(destination: FilesView(),
                               tag: UserState.loggedIn,
                               selection: Binding<UserState?>($state.userState)) {
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
