//
//  TaskListView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI
import Firebase

struct TaskListView: View {
    @State private var tasks: [Task] = []

    @EnvironmentObject var taskService: TaskService
    @State private var activeSheet: ActiveSheet?

    enum ActiveSheet: Identifiable {
        case addTask, taskDetail(Task)

        var id: Int {
            switch self {
            case .addTask:
                return 1
            case .taskDetail:
                return 2
            }
        }
    }

    var body: some View {
        NavigationView {
            List(taskService.tasks) { task in
                Button(action: {
                    activeSheet = .taskDetail(task)
                }) {
                    TaskRow(task: task)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        activeSheet = .addTask
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .addTask:
                    AddTaskView { task in
                        tasks.append(task)
                        activeSheet = nil
                    }
                case .taskDetail(let task):
                    TaskDetailView(task: task).environmentObject(taskService)
                }
            }
        }.onAppear {
            taskService.fetchTasks()
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
