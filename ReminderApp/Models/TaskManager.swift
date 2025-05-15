//
//  TaskManager.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 13.05.2025.
//

import Foundation

class TaskManager {
    
    // MARK: - Properties
    static var shared = TaskManager()
    var tasks: [TaskModel] = []
    
    // MARK: - Functions
    func addTask(_ task: TaskModel) {
        tasks.append(task)
    }
    
}
