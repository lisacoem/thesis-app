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
         unavailable
}

enum HttpMethod: String, CaseIterable {
    case get = "GET",
         post = "POST",
         put = "PUT",
         delete = "DELETE"
}

struct Http {
    
    static let baseUrl = "https://b23f-2a02-810b-54c0-1690-75f1-9df1-c59c-86a6.ngrok.io/api/v1"
    
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
    
    static func request<ResponseData: Decodable>(
        _ url: URL,
        method: HttpMethod,
        payload: Data? = nil,
        receive type: ResponseData.Type
    ) -> AnyPublisher<ResponseData, HttpError> {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.authorizationToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
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
    
    static func deleteRequest(_ url: URL) -> AnyPublisher<Void, HttpError> {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.authorizationToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = HttpMethod.delete.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .retry(3)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw HttpError.unavailable
                }
                if response.statusCode == 204 {
                    return
                }
                else if response.statusCode == 401 {
                    Keychain.authorizationToken = nil
                    UserDefaults.standard.clear()
                    throw HttpError.unauthorized
                } else {
                    throw HttpError.serverError
                }
            }
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
    
    

}
