//
//  TaskService.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class TaskService: ObservableObject {
    @Published var tasks: [Task] = []
    @State private var selectedExecutor: User?
    private let db = Firestore.firestore()
    @Published var executors: [User] = []
    
    func addTask(title: String, description: String, dueDate: Date, executorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let taskData: [String: Any] = [
            "title": title,
            "description": description,
            "status": TaskStatus.active.rawValue,
            "dueDate": dueDate,
            "executorId": executorId
        ]
        
        db.collection("tasks").addDocument(data: taskData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func updateTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        let taskData: [String: Any] = [
            "title": task.title,
            "description": task.description,
            "status": task.status.rawValue,
            "dueDate": task.dueDate
        ]
        
        db.collection("tasks").document(task.id).setData(taskData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("tasks").document(task.id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addTaskToFirestore(task: Task) {
        let tasksRef = db.collection("tasks")

        tasksRef.document(task.id).setData([
            "title": task.title,
            "description": task.description,
            "status": task.status.rawValue,
            "dueDate": task.dueDate,
            "executorId": task.executorId
        ]) { error in
            if let error = error {
                print("Error adding task to Firestore: \(error.localizedDescription)")
            } else {
                print("Task added successfully")
            }
        }
    }
    
    func fetchExecutors() {
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
            
            if let firstExecutor = executors.first {
                selectedExecutor = firstExecutor
            }
        }
    }


    func fetchTasks() {
        db.collection("tasks").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching tasks: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetching tasks: No documents found")
                return
            }
            
            self.tasks = documents.compactMap { document in
                guard let title = document.data()["title"] as? String,
                      let description = document.data()["description"] as? String,
                      let statusRawValue = document.data()["status"] as? String,
                      let status = TaskStatus(rawValue: statusRawValue),
                      let dueDateTimestamp = document.data()["dueDate"] as? Timestamp,
                      let executorId = document.data()["executorId"] as? String else {
                    print("Error fetching tasks: Missing or invalid fields")
                    return nil
                }
                
                let dueDate = dueDateTimestamp.dateValue()
                
                return Task(id: document.documentID, title: title, description: description, status: status, dueDate: dueDate, executorId: executorId)
            }
        }
    }

    func fetchUserById(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documentSnapshot = documentSnapshot,
                  documentSnapshot.exists,
                  let email = documentSnapshot.data()?["email"] as? String,
                  let roleRawValue = documentSnapshot.data()?["role"] as? String,
                  let role = UserRole(rawValue: roleRawValue) else {
                completion(.failure(NSError(domain: "TaskService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid fields"])))
                return
            }
            
            let user = User(id: documentSnapshot.documentID, email: email, role: role)
            completion(.success(user))
        }
    }

    func deleteTask(taskId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("tasks").document(taskId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }



    
    
    func updateOverdueTasks() {
        let now = Date()
        let calendar = Calendar.current
        let components = Set<Calendar.Component>([.day, .month, .year])
        
        self.db.collection("tasks").whereField("status", isEqualTo: TaskStatus.active.rawValue).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error updating overdue tasks: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Error updating overdue tasks: No documents found")
                return
            }
            
            for document in documents {
                guard let dueDate = document.data()["dueDate"] as? Timestamp else {
                    print("Error updating overdue tasks: Missing or invalid dueDate field")
                    continue
                }
                
                let dueDateComponents = calendar.dateComponents(components, from: dueDate.dateValue())
                let nowComponents = calendar.dateComponents(components, from: now)
                
                if calendar.date(from: nowComponents)! > calendar.date(from: dueDateComponents)! {
                    let taskId = document.documentID
                    self.db.collection("tasks").document(taskId).updateData(["status": TaskStatus.overdue.rawValue]) { error in
                        if let error = error {
                            print("Error updating overdue tasks: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
