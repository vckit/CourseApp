//
//  LoginView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image("palestina")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("We stand with Palestina")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
            }
            .padding()
            
            Text("Design Studio")
                .multilineTextAlignment(.center)
                .font(.title)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.bottom)
            
            Button("Sign In") {
                authService.signIn(email: email, password: password) { result in
                    switch result {
                    case .success: break
                    case .failure(let error):
                        showErrorAlert = true
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

