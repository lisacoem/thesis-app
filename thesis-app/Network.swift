//
//  Network.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

struct NetworkController {
    static let baseUrl = "https://4dbb-2a02-810b-54c0-1690-d1b8-1aef-c560-86a2.ngrok.io/api/v1"
    
    private static func buildRequest(with request: URLRequest, onSuccess: @escaping (Data) -> Void) -> URLSessionDataTask {
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
    
    static func login(_ data: UserLoginDto) throws {
        if let url = URL(string: baseUrl + "/user/login") {
            let encoder = JSONEncoder()
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            request.httpBody = try encoder.encode(data)
            
            let task = buildRequest(with: request) { responseData in
                do {
                    let responseObject = try JSONDecoder().decode(UserDto.self, from: responseData)
                    print(responseObject)
                } catch {
                    print(error)
                }
            }
            
            task.resume()
        }
    }
    
    static func register(_ data: UserDto) throws {
        if let url = URL(string: baseUrl + "/user/register") {
            let encoder = JSONEncoder()
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            request.httpBody = try encoder.encode(data)
            
            let task = buildRequest(with: request) { responseData in
                do {
                    let responseObject = try JSONDecoder().decode(UserDto.self, from: responseData)
                    print(responseObject)
                } catch {
                    print(error)
                }
            }
            
            task.resume()
        }
    }
    
    
}
