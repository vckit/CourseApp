//
//  AddTaskView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI
import FirebaseFirestore

let db = Firestore.firestore()

struct AddTaskView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var title = ""
    @State private var email = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @Environment(\.presentationMode) var presentationMode
    var onTaskAdded: ((Task) -> Void)?
    
    @State private var executors: [User] = []
    @State private var selectedExecutor: User?
    @EnvironmentObject var taskService: TaskService
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                
                Picker("Executor", selection: $selectedExecutor) {
                    ForEach(taskService.executors, id: \.id) { executor in
                        Text(executor.email).tag(executor)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                
                Button("Add Task") {
                    guard let selectedExecutor = selectedExecutor else {
                        // Выберите исполнителя, если он не выбран
                        alertMessage = "Please select an executor."
                        showAlert = true
                        return
                    }
                    
                    let task = Task(id: UUID().uuidString, title: title, description: description, status: .active, dueDate: dueDate, executorId: selectedExecutor.id)
                    onTaskAdded?(task)
                    presentationMode.wrappedValue.dismiss()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            fetchExecutors()
        }
    }
    
    private func fetchExecutors() {
        db.collection("users").whereField("role", isEqualTo: UserRole.executer.rawValue).getDocuments { [self] querySnapshot, error in
            if let error = error {
                print("Error fetching executors: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetching executors: No documents found")
                return
            }
            
            executors = documents.compactMap { document in
                guard let email = document.data()["email"] as? String else {
                    print("Error fetching executors: Missing or invalid email field")
                    return nil
                }
                
                return User(id: document.documentID, email: email, role: .executer)
            }
        }
    }
    
    
    struct AddTaskView_Previews: PreviewProvider {
        static var previews: some View {
            AddTaskView()
        }
    }
}
