//
//  AuthService.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    @Published var currentUserRole: UserRole?
    private let db = Firestore.firestore()

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = result?.user.uid else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing user ID"])
                completion(.failure(error))
                return
            }
            
            self?.fetchUserRole(uid: uid) { role in
                self?.currentUserRole = role
                completion(.success(()))
            }
        }
    }


    func fetchUserRole(uid: String, completion: @escaping (UserRole?) -> Void) {
        db.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("Error fetching user role: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("Error fetching user role: Document does not exist")
                completion(nil)
                return
            }
            
            guard let data = document.data() else {
                print("Error fetching user role: Document data is nil")
                completion(nil)
                return
            }
            
            guard let roleString = data["role"] as? String else {
                print("Error fetching user role: 'role' field is missing or has an invalid type")
                completion(nil)
                return
            }
            
            guard let role = UserRole(rawValue: roleString) else {
                print("Error fetching user role: Invalid role value '\(roleString)'")
                completion(nil)
                return
            }
            
            completion(role)
        }
    }
    
    func createUser(email: String, password: String, role: UserRole, completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let uid = result?.user.uid else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing user ID"])
                    completion(.failure(error))
                    return
                }
                
                self?.db.collection("users").document(uid).setData(["role": role.rawValue]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUserRole = nil
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

}

