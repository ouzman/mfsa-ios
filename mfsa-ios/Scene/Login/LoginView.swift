//
//  LoginView.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 12.12.2020.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let alertActive = Binding<Bool>(
            get: { self.viewModel.errorAlertDetails != nil },
            set: { if !$0 { self.viewModel.errorAlertDetails = nil } }
        )
                
        VStack(alignment: .center, spacing: nil, content: {
            Spacer()
            self.titleSection
            Spacer()
            self.signInMessageSection
                .padding()
            self.loginButtons
                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity,
                       maxHeight: 40,
                       alignment: .center)
                .padding(.all)
                .padding(.bottom, 20)
        })
        .alert(isPresented: alertActive, content: {
            Alert(title: Text(self.viewModel.errorAlertDetails!.title),
                  message: Text(self.viewModel.errorAlertDetails!.details),
                  dismissButton: .default(Text("OK")))
        })
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    var titleSection: some View {
        VStack(content: {
            Text("Mobile File")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.blue)
            Text("Sharing App")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.blue)
        })
    }
    
    var signInMessageSection: some View {
        HStack() {
            VStack(alignment: .leading, spacing: nil, content: {
                Text("Sign In")
                    .bold()
                    .font(.title)
                Text("Hi there! This is a simple, file sharing application.")
                    .font(.callout)
            })
            Spacer()
        }
    }
    
    var facebookButton: some View {
        Button(action: {
            viewModel.facebookLogin()
        }) {
            Text("Facebook")
                .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity,
                       minHeight: 0, idealHeight: 100, maxHeight: .infinity,
                       alignment: .center)

        }
        .foregroundColor(.white)
        .background(Color(.systemBlue))
    }
    
    var twitterButton : some View {
        Button(action: { }) {
            Text("Twitter")
                .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity,
                       minHeight: 0, idealHeight: 100, maxHeight: .infinity,
                       alignment: .center)
        }
            .foregroundColor(.white)
            .background(Color(.systemBlue))
    }
    
    var loginButtons : some View {
        VStack {
            self.facebookButton
//            Spacer()
//            self.twitterButton
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            
            LoginView(viewModel: LoginViewModel())
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
                .previewDisplayName("iPhone 12 Pro Max")
        }
    }
}
