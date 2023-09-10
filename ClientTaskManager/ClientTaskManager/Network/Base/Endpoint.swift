//
//  Endpoint.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//

import Foundation
protocol Endpoint{
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
    var port: Int? { get }
}

extension Endpoint {
    var scheme: String {
        return "http"}
    
    var header: [String: String]? {
        return ["Content-Type": "application/json"]}
    
    var host: String {
        //return "localhost"
       return "192.168.1.5"
    }
    var port: Int? {
        return 8080 }
}
