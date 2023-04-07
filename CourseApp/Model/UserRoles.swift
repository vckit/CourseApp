//
//  UserRoles.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

enum UserRole: String, CaseIterable, Identifiable {
    case manager = "manager"
    case executer = "executer"

    var id: String { rawValue }
}
