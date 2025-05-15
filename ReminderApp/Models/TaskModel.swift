//
//  TaskModel.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 9.05.2025.
//

import Foundation

struct TaskModel: Equatable {
    let id: UUID = UUID()
    var text: String?
    var isDone: Bool = false
    var date: Date?

    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        return lhs.id == rhs.id
    }
}
