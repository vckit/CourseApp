//
//  EmployeeView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct EmployeeView: View {
    @EnvironmentObject var taskService: TaskService
    @EnvironmentObject var authService: AuthService
    
    private var filteredTasks: [Task] {
        taskService.tasks.filter { task in
            if let currentUser = authService.currentUser, task.executorId == currentUser.id {
                return task.status == .active
            }
            return false
        }
    }

    
    
    func fetchAssignedTasks() {
            guard let userId = authService.currentUser?.id else { return }
            
            fetchTasksAssignedToUser(userId: userId) { result in
                switch result {
                case .success(let fetchedTasks):
                    taskService.tasks = fetchedTasks
                case .failure(let error):
                    print("Error fetching tasks for executer: \(error.localizedDescription)")
                }
            }
        }
    
    func fetchTasksAssignedToUser(userId: String, completion: @escaping (Result<[Task], Error>) -> Void) {
        taskService.getTasksAssignedToUser(userId: userId, completion: completion)
    }
    
    
    func updateTaskStatus(task: Task, newStatus: TaskStatus) {
        let updatedTask = Task(id: task.id, title: task.title, description: task.description, status: newStatus, dueDate: task.dueDate, executorId: task.executorId)
        
        taskService.updateTask(task: updatedTask) { result in
            switch result {
            case .success:
                taskService.tasks.removeAll { $0.id == task.id }
            case .failure(let error):
                print("Error updating task status: \(error.localizedDescription)")
            }
        }
    }

    
    var body: some View {
        NavigationView {
            List(filteredTasks) { task in
                NavigationLink(destination: TaskDetailViewExecuter(task: task)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(task.title).font(.headline)
                        Text(task.description).font(.subheadline).foregroundColor(.gray)
                    }
                    if task.status == .active {
                        Button("Mark as Completed") {
                            updateTaskStatus(task: task, newStatus: .completed)
                        }
                    }
                }
            }
            .navigationTitle("Assigned Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        authService.signOut()
                    }) {
                        Image(systemName: "person.crop.circle.badge.xmark")
                    }
                }
            }
        }
        .onAppear(perform: fetchAssignedTasks)
    }
}

struct EmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeView()
    }
}
