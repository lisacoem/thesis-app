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
    
    static let baseUrl = "https://7da8-2a02-810b-54c0-1690-7c77-3b52-ded1-e9a8.ngrok.io/api/v1"
    
    static let encoder: JSONEncoder = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = JSONEncoder()
        result.dateEncodingStrategy = .formatted(formatter)
        return result
    }()
    
    static let decoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = JSONDecoder()
        result.dateDecodingStrategy = .formatted(formatter)
        return result
    }()
    
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
}
