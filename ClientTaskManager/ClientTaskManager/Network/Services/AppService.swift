//
//  AppService.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//

import Foundation
struct AppService: HTTPClient {
    
    func login(email: String, password: String) async -> Result<User, RequestError> {
        return await sendRequest(endpoint: AppEndpoint.login(email: email, password: password), responseModel: User.self)
    }
    
    func register(name: String, email: String, password: String) async -> Result<User, RequestError> {
        return await sendRequest(endpoint: AppEndpoint.register(name: name, email: email, password: password), responseModel: User.self)
    }
    
    func getTasks() async -> Result<[TaskModel], RequestError> {
        return await sendRequest(endpoint: AppEndpoint.tasks, responseModel: [TaskModel].self)
    }
    
    func addTasks(title: String, description: String, priority: String, dueDate: String, status: String) async -> Result<TaskModel, RequestError> {
        return await sendRequest(endpoint: AppEndpoint.addTask(title: title, description: description, priority: priority, dueDate: dueDate, status: status), responseModel: TaskModel.self)
    }
    
    func deleteTask(taskId: Int) async -> Result<TaskModel, RequestError> {
        return await sendRequest(endpoint: AppEndpoint.deleteTask(taskId: taskId), responseModel: TaskModel.self)
    }
    
    
}
