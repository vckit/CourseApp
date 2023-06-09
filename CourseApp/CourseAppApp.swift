//
//  CourseAppApp.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct CourseAppApp: App {
    @EnvironmentObject var taskService: TaskService
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthService())
        }
    }
}
