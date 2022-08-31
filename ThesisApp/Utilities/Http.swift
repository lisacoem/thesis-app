//
//  Http.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation
import Combine

enum HttpError: Error {
    case invalidUrl,
         invalidData,
         serverError,
         unauthorized,
         unavailable,
         unnecessary
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
    
    static func post<ResponseData: Decodable>(
        _ url: URL,
        payload: Data,
        receive type: ResponseData.Type
    ) -> AnyPublisher<ResponseData, HttpError> {
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.authorizationToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "POST"
        request.httpBody = payload
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .retry(3)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HttpError.unavailable
                }
                if (200 ... 299) ~= response.statusCode {
                    return output.data
                }
                else if response.statusCode == 401 {
                    Keychain.authorizationToken = nil
                    UserDefaults.standard.clear()
                    throw HttpError.unauthorized
                } else {
                    throw HttpError.serverError
                }
            }
            .decode(type: ResponseData.self, decoder: Http.decoder)
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                    return HttpError.invalidData
                case is URLError:
                    return HttpError.unavailable
                case is HttpError:
                    return error as! HttpError
                default:
                    return HttpError.serverError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func get<ResponseData: Decodable>(
        _ url: URL,
        receive type: ResponseData.Type
    ) -> AnyPublisher<ResponseData, HttpError> {
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.authorizationToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .retry(3)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HttpError.unavailable
                }
                if (200 ... 299) ~= response.statusCode {
                    return output.data
                }
                else if response.statusCode == 403 {
                    throw HttpError.unauthorized
                } else {
                    throw HttpError.serverError
                }
            }
            .decode(type: ResponseData.self, decoder: Http.decoder)
            .mapError { error in
                switch error {
                case is Swift.DecodingError:
                    return HttpError.invalidData
                case is URLError:
                    return HttpError.unavailable
                default:
                    return HttpError.serverError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
