//
//  AddTaskView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI
import Firebase
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
                        Text(executor.email).tag(Optional(executor)) // Используйте 'Optional(executor)' вместо 'executor'
                    }
                }
                
                
                Button("Add Task") {
                    guard let selectedExecutor = selectedExecutor else {
                        // Выберите исполнителя, если он не выбран
                        alertMessage = "Please select an executor."
                        showAlert = true
                        return
                    }
                    
                    let task = Task(id: UUID().uuidString, title: title, description: description, status: .active, dueDate: dueDate, executorId: selectedExecutor.id)
                    taskService.addTaskToFirestore(task: task)
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
            taskService.fetchExecutors()
        }
    }
    
    struct AddTaskView_Previews: PreviewProvider {
        static var previews: some View {
            AddTaskView()
        }
    }
}
