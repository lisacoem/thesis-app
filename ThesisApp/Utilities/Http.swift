//
//  Http.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation

struct Http {
    
    static func post(
        _ url: URL,
        payload: Dto,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) throws -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Application.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(payload)
        
        return fetch(request, completion: completion)
    }
    
    static func get(
        _ url: URL,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Application.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return fetch(request, completion: completion)
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
