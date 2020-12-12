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

            HStack() {
                self.signInMessage
                Spacer()
            }
            .padding()
            
            self.loginButtons
                .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity,
                       maxHeight: 80,
                       alignment: .center)
                .padding(.all)
                .padding(.bottom, 20)
        })
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: alertActive, content: {
            Alert(title: Text(self.viewModel.errorAlertDetails!.title),
                  message: Text(self.viewModel.errorAlertDetails!.details),
                  dismissButton: .default(Text("OK")))
        })
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
    
    var signInMessage: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            Text("Sign In")
                .bold()
                .font(.title)
            Text("Hi there! This is a simple, file sharing application.")
                .font(.callout)
        })
    }
    
    var loginButtons: some View {
        VStack {
            Button("Facebook", action: {
                viewModel.facebookLogin()
            })
                .foregroundColor(.white)
                .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity,
                       minHeight: 0, idealHeight: 100, maxHeight: .infinity,
                       alignment: .center)
                .background(Color(.systemBlue))
            Spacer()
            Button("Twitter", action: { })
                .foregroundColor(.white)
                .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity,
                       minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                .background(Color(.systemBlue))
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
