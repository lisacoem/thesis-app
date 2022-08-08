//
//  Http.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation

struct Http {
    
    static func post(_ url: URL, payload: Dto, onSuccess: @escaping (Data) -> Void) throws -> URLSessionDataTask {
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(payload)
        
        return fetch(request) { data in
            onSuccess(data)
        }
    }
    
    static func get(_ url: URL, onSuccess: @escaping (Data) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        
        return fetch(request) { data in
            onSuccess(data)
        }
    }
    
    static func fetch(_ request: URLRequest, onSuccess: @escaping (Data) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            onSuccess(data)
        }
    }
    
}
