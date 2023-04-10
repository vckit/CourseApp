//
//  TaskDetailViewExecuter.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/10/23.
//

import SwiftUI

struct TaskDetailViewExecuter: View {
    @EnvironmentObject var taskService: TaskService
    @Environment(\.presentationMode) var presentationMode
    @State private var task: Task
    @State private var newStatus: TaskStatus

    init(task: Task) {
        _task = State(initialValue: task)
        _newStatus = State(initialValue: task.status)
    }

    func updateTaskStatus() {
        task.status = newStatus

        taskService.updateTask(task: task) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
                print("Task status updated successfully.")
            case .failure(let error):
                print("Error updating task status: \(error.localizedDescription)")
            }
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                Text("Title: \(task.title)")
                Text("Description: \(task.description)")
                Text("Due Date: \(task.dueDate, formatter: DateFormatter())")
            }

            Section(header: Text("Status")) {
                Picker("Status", selection: $newStatus) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue.capitalized).tag(status)
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            updateTaskStatus()
        })
        .navigationTitle("Task Details")
    }
}

