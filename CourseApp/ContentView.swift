//
//  ContentView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authService: AuthService
    @StateObject var taskService = TaskService() // добавьте эту строку


        var body: some View {
            Group {
                if let userRole = authService.currentUserRole {
                    switch userRole {
                    case .manager:
                        ManagerView().environmentObject(taskService)
                    case .executer:
                        EmployeeView().environmentObject(taskService)
                    }
                } else {
                    LoginView()
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
