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
        if let url = URL(string: baseUrl + "/user/login") {
            let task = try Http.post(url, payload: data) { responseData in
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
        if let url = URL(string: baseUrl + "/user/signup") {
            let task = try Http.post(url, payload: data) { responseData in
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
