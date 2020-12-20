//
//  LogoutButton.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 20.12.2020.
//

import SwiftUI

struct LogoutButton: View {
    @State private var showAlert = false
    
    var body: some View {
        Button("Logout", action: { self.showAlert = true })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Logout"),
                      message: Text("User will be logged out. Are you sure?"),
                      primaryButton: .destructive(Text("Logout").bold(),
                                              action: { LoginService.instance.logout() }),
                      secondaryButton: .cancel())
            })
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
