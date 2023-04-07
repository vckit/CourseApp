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
    private let db = Firestore.firestore()
    
    func addTask(title: String, description: String, dueDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        let taskData: [String: Any] = [
            "title": title,
            "description": description,
            "status": TaskStatus.active.rawValue,
            "dueDate": dueDate
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
