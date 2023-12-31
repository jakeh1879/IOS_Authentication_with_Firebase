//
//  LoginView.swift
//  auth_app_test
//
//  Created by Jacob Hefele on 7/15/23.
//

import SwiftUI

//View shown to users that already have an account
//Allows log in prior to profile view

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {

            //Hammer image at top of view

            Image("hammer_white").resizable().scaledToFill().frame(width: 100,height: 120).padding(.vertical, 32)
            
            
            VStack(spacing: 24){
                InputView(text: $email, title: "Email Address", placeHolder: "name@example.com").autocapitalization(.none)
                InputView(text: $password, title: "Password", placeHolder: "Enter your password", isSecureField: true)
            }
            .padding(.horizontal).padding(.top, 12)
            
            //Sign in button
            
            Button {
                Task {
                    try await viewModel.signIn(withEmail: email, password: password) //async throws
                }
            } label: {
                HStack{
                    Text("SIGN IN").fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }.foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            
            Spacer()
            
            //Add back button
            
            NavigationLink {
                RegistrationView().navigationBarBackButtonHidden(true)
            } label: {
                
                HStack(spacing:2){
                    Text("Don't have an account?")
                    Text("Sign Up").fontWeight(.bold).font(.system(size:14))
                }
            }   
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
