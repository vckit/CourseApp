//
//  User.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/10/23.
//

import SwiftUI

struct User: Identifiable, Hashable {
    let id: String
    let email: String
    let role: UserRole
    
    init(id: String, email: String, role: UserRole) {
        self.id = id
        self.email = email
        self.role = role
    }
}
