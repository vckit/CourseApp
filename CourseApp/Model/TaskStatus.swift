//
//  TaskStatus.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import Foundation


enum TaskStatus: String, CaseIterable, Identifiable {
    case unassigned = "unassigned"
    case active = "active"
    case completed = "completed"
    case overdue = "overdue"

    var id: String { rawValue }
}
