//
//  TaskListView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct TaskListView: View {
    @State private var tasks: [Task] = []
    @State private var showAddTaskView = false
    
    var body: some View {
        NavigationView {
            List(tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task)) {
                    TaskRow(task: task)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTaskView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView { task in
                    tasks.append(task)
                    showAddTaskView = false
                }
            }
        }
    }
}


struct TaskRow: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.title).font(.headline)
            Text(task.description).font(.subheadline).foregroundColor(.gray)
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
