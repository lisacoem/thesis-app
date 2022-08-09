//
//  Network.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

struct NetworkController {
    static let baseUrl = "https://4dbb-2a02-810b-54c0-1690-d1b8-1aef-c560-86a2.ngrok.io/api/v1"
    
    static func login(_ data: UserLoginDto) throws {
        if let url = URL(string: baseUrl + "/auth/login") {
            let task = try Http.post(url, payload: data) { result in
                switch result {
                case .success(let responseData):
                    do {
                        let responseObject = try JSONDecoder().decode(UserDto.self, from: responseData)
                        Application.token = responseObject.token
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    static func register(_ data: UserDto) throws {
        //Application.token = nil
        if let url = URL(string: baseUrl + "/auth/signup") {
            let task = try Http.post(url, payload: data) { result in
                switch result {
                case .success(let responseData):
                    do {
                        let responseObject = try JSONDecoder().decode(UserDto.self, from: responseData)
                        Application.token = responseObject.token
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
}
