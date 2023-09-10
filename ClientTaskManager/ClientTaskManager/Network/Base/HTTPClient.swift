//
//  HTTPClient.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//

import Foundation
protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = endpoint.port
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
       request.httpMethod = endpoint.method.rawValue
       request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        print(url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }

            switch response.statusCode {
            case 200...299:
                //try! JSONDecoder().decode(responseModel, from: data)
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                print(response.statusCode)
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
