//
//  LogoutButton.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 20.12.2020.
//

import SwiftUI

struct LogoutButton: View {
    var body: some View {
        Button("Logout", action: { })
    }
}

struct LogoutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogoutButton()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
