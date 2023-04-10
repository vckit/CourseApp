//
//  TaskDetailView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct TaskDetailView: View {
    let task: Task
    @EnvironmentObject var taskService: TaskService
    @State private var title: String
    @State private var description: String
    @State private var status: TaskStatus
    @State private var executor: User?
    @State private var dueDate: Date
    
    @Environment(\.presentationMode) var presentationMode
    
    init(task: Task) {
        self.task = task
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description)
        self._status = State(initialValue: task.status)
        self._dueDate = State(initialValue: task.dueDate)
        self._executor = State(initialValue: nil)
    }
    
    func saveTask() {
        let updatedTask = Task(id: task.id, title: title, description: description, status: status, dueDate: dueDate, executorId: task.executorId)
        taskService.updateTask(task: updatedTask) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Error updating task: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask() {
        taskService.deleteTask(taskId: task.id) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Information")) {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            
            Section(header: Text("Status")) {
                Picker("Status", selection: $status) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue.capitalized).tag(status)
                    }
                }
            }
            
            Section(header: Text("Executor")) {
                if let executor = executor {
                    Text(executor.email)
                } else {
                    Text("Loading...")
                }
            }
            
            Section(header: Text("Due Date")) {
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            }
            
            Section {
                Button("Delete Task", action: deleteTask)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Task Detail")
        .navigationBarItems(trailing: Button("Save", action: saveTask))
        
        .onAppear {
            loadExecutor()
        }
    }
    
    func loadExecutor() {
        taskService.fetchUserById(userId: task.executorId) { result in
            switch result {
            case .success(let user):
                executor = user
            case .failure(let error):
                print("Error loading executor: \(error.localizedDescription)")
            }
        }
    }
    
}
