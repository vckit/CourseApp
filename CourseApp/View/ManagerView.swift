//
//  ManagerView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct ManagerView: View {
    @State private var showAddUserView = false
    
    @EnvironmentObject var taskService: TaskService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                NavigationLink(destination: TaskListView()) {
                    Text("Tasks")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .environmentObject(taskService)
                Button(action: {
                    showAddUserView = true
                }) {
                    Text("Add User")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showAddUserView) {
                    AddUserView(onUserCreated: {
                        showAddUserView = false
                    })
                }
                
            }
            .padding()
            .navigationTitle("Manager View")
        }
    }
}

struct ManagerView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerView()
    }
}
