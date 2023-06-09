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
    var status: TaskStatus
    let dueDate: Date
    let executorId: String
}

