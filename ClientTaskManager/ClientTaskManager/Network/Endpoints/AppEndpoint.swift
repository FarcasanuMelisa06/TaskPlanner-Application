//
//  AppEndpoint.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//

import Foundation
enum AppEndpoint {
    case login(email: String, password: String)
    case register(name: String, email: String, password: String)
    case tasks
    case addTask(title: String, description: String, priority: String, dueDate: String, status: String)
    case deleteTask(taskId: Int)
}

extension AppEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .login:
            return "/api/login"
        case .register:
            return "/api/register"
        case .tasks:
            return "/api/tasks"
        case .addTask:
            return "/api/addTask"
        case .deleteTask(let taskId):
            return "/api/delete/\(taskId)"
    
        }
    }

    var method: RequestMethod {
        switch self {
        case .login, .register, .addTask:
            return .post
        case .tasks:
            return .get
        case .deleteTask:
            return .delete
    
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return ["email": "\(email)",
                    "password": "\(password)"
            ]
        case .register(let name, let email, let password):
            return ["name": "\(name)",
                    "email": "\(email)",
                    "password": "\(password)"
            ]
        case .tasks, .deleteTask:
            return nil
            
        case .addTask(let title, let description, let priority, let dueDate, let status):
            return ["title": "\(title)",
                    "description": "\(description)",
                    "priority": "\(priority)",
                    "dueDate": "\(dueDate)",
                    "status": "\(status)"
            ]

        }
    }
}
