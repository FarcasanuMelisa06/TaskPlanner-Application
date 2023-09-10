//
//  AppManager.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//

import Foundation

protocol ManagerInjector {
    var manager: Manager { get }
}

private let sharedInstance: Manager = Manager()

extension ManagerInjector {
    var manager: Manager {
        return sharedInstance
    }
}

class Manager {
    
    let defaults = UserDefaults.standard
    
    
    internal var token: String? {
        get {
            return self.defaults.string(forKey: "token")
        } set {
            self.defaults.set(newValue, forKey: "token")
        }
    }
}
