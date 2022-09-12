//
//  Api.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation
import Combine

enum ApiError: Error {
    case invalidUrl,
         invalidData,
         serverError,
         unauthorized,
         unavailable
}

enum API {
    
    static var baseUrl: URL {
        return try! URL(string: "https://" + Configuration.value(for: "API_BASE_URL"))!
    }
    
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
    
    static func get<ResponseData: Decodable>(_ url: URL, receive type: ResponseData.Type) -> AnyPublisher<ResponseData, ApiError> {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.authorizationToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "GET"
        return fetch(request, decodable: type)
    }
    
    static func post<ResponseData: Decodable>(
        _ url: URL,
        payload: Data,
        receive type: ResponseData.Type
    ) -> AnyPublisher<ResponseData, ApiError> {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.authorizationToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        request.httpBody = payload
        return fetch(request, decodable: type)
    }
    
    static func delete(_ url: URL) -> AnyPublisher<Void, ApiError> {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.authorizationToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "DELETE"
        return fetch(request)
    }
}

extension API {
    
    private static func fetch<ResponseData: Decodable>(_ request: URLRequest, decodable: ResponseData.Type) -> AnyPublisher<ResponseData, ApiError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .retry(3)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw ApiError.unavailable
                }
                if (200 ... 299) ~= response.statusCode {
                    return output.data
                }
                else if response.statusCode == 401 {
                    Keychain.authorizationToken = nil
                    UserDefaults.standard.clear()
                    throw ApiError.unauthorized
                } else {
                    throw ApiError.serverError
                }
            }
            .decode(type: ResponseData.self, decoder: API.decoder)
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                    return ApiError.invalidData
                case is URLError:
                    return ApiError.unavailable
                case is ApiError:
                    return error as! ApiError
                default:
                    return ApiError.serverError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private static func fetch(_ request: URLRequest) -> AnyPublisher<Void, ApiError> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .retry(3)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw ApiError.unavailable
                }
                if (200 ... 299) ~= response.statusCode {
                    return
                }
                else if response.statusCode == 401 {
                    Keychain.authorizationToken = nil
                    UserDefaults.standard.clear()
                    throw ApiError.unauthorized
                } else {
                    throw ApiError.serverError
                }
            }
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                    return ApiError.invalidData
                case is URLError:
                    return ApiError.unavailable
                case is ApiError:
                    return error as! ApiError
                default:
                    return ApiError.serverError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
