//
//  ContentView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 6.12.2020.
//

import SwiftUI
import FBSDKLoginKit
import AWSCore
import AWSMobileClient

struct ContentView: View {
    @ObservedObject var fbmanager = UserLoginManager()
    @State fileprivate var showAlert = false
    @State fileprivate var errorMessage: String = ""

    var body: some View {
        VStack() {
            Text("Hello, world!")
            Button("Facebook Login", action: {
                self.fbmanager.facebookLogin(parent: self)
            })
            Button("Facebook Logout", action: {
                self.fbmanager.facebookLogout()
            })
            .alert(isPresented: $showAlert) { () -> Alert in
                if errorMessage.isEmpty {
                    let alert = Alert(title: Text("Login Success"))
                    
                    return alert

                } else {
                    let alert = Alert(title: Text("Login Failed"),
                          message: Text(self.errorMessage),
                          dismissButton: .default(Text("OK")))
                    return alert;
                }
             }
        }
    }
}

class UserLoginManager: ObservableObject {
    let loginManager = LoginManager()
    
    func facebookLogout() {
        loginManager.logOut()
    }
    
    func facebookLogin(parent: ContentView) {
        loginManager.logIn(permissions: [.email], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                parent.errorMessage = error.localizedDescription
                parent.showAlert = true
            case .cancelled:
                parent.errorMessage = "Need to login to use the application"
                parent.showAlert = true
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                if declinedPermissions.contains(FBSDKCoreKit.Permission.email) {
                    parent.errorMessage = "Need to permit to read email address to use the application"
                    parent.showAlert = true
                } else {
                    print("Logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                    GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil){
                            let fbDetails = result as! NSDictionary
                            print(fbDetails)
                        }
                    })
                    
                    
                    AWSMobileClient
                        .default()
                        .federatedSignIn(providerName: IdentityProvider.facebook.rawValue,
                                         token: accessToken.tokenString) { (userState, error)  in
                        if let error = error {
                            print("Federated Sign In failed: \(error.localizedDescription)")
                        } else {
                            print("\(userState!)")
                        }
                    }
                    
                    parent.errorMessage = ""
                    parent.showAlert = true

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
