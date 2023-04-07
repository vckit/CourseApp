//
//  Task.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//


import SwiftUI

struct Task: Identifiable {
    let id: String
    let title: String
    let description: String
    let status: TaskStatus
    let dueDate: Date
}
