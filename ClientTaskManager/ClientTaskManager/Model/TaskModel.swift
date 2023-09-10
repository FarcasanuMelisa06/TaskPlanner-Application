//
//  TaskModel.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 26.07.2023.
//

import Foundation

struct TaskModel: Codable {
    var taskId: Int
    var title: String
    var description: String
    var priority: String
    var dueDate: String
    var status: String
}
