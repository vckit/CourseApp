//
//  AddUserView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct AddUserView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var role: UserRole = .executer
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @EnvironmentObject var authService: AuthService
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                
                SecureField("Password", text: $password)
                
                Picker("Role", selection: $role) {
                    ForEach(UserRole.allCases) { role in
                        Text(role.rawValue.capitalized).tag(role)
                    }
                }
                
                Button("Create User") {
                    authService.createUser(email: email, password: password, role: role) { result in
                        switch result {
                        case .success:
                            authService.signOut()
                            presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            showErrorAlert = true
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Add User")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
