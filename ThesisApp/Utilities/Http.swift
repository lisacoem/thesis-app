//
//  Http.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation

enum HttpError: Error {
    case invalidUrl, invalidData, serverError, unauthorized
}

struct Http {
    
    static let baseUrl = "https://6dae-2a02-810b-54c0-1690-e5f3-452f-556e-c49e.ngrok.io/api/v1"
    
    static func post(
        _ url: URL,
        payload: Data,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = SessionStorage.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        request.httpBody = payload
        
        return fetch(request, completion: completion)
    }
    
    static func post(_ url: URL, payload: Data) -> URLSession.DataTaskPublisher {
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = SessionStorage.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        request.httpBody = payload
        
        return URLSession.shared.dataTaskPublisher(for: request)
    }
    
    static func get(
        _ url: URL,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = SessionStorage.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return fetch(request, completion: completion)
    }
    
    static func get(_ url: URL) -> URLSession.DataTaskPublisher {
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = SessionStorage.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
    }
    
    static func fetch(
        _ request: URLRequest,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                completion(.failure(
                    URLError(URLError.Code(rawValue: response.statusCode)))
                )
                return
            }
            
            completion(.success(data))
        }
    }
}
