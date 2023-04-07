//
//  AddTaskView.swift
//  CourseApp
//
//  Created by Абдулхаким Магомедов on 4/7/23.
//

import SwiftUI

struct AddTaskView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @Environment(\.presentationMode) var presentationMode
    var onTaskAdded: ((Task) -> Void)?

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Button("Add Task") {
                    let task = Task(id: UUID().uuidString, title: title, description: description, status: .active, dueDate: dueDate)
                    onTaskAdded?(task)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
