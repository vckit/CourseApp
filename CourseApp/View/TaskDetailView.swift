//
//  TaskDetailView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct TaskDetailView: View {
    let task: Task
    @State private var title: String
    @State private var description: String
    
    init(task: Task) {
        self.task = task
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Information")) {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            
            Section {
                Button("Delete Task", action: {
                    // Удалите задачу здесь
                })
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Task Detail")
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(task: Task(id: "1", title: "Test Task", description: "This is a test task", status: .active, dueDate: Date()))
    }
}

