//
//  Web.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

struct WebService {
    
    static func login(_ data: LoginData) throws -> UserData? {
        var userData: UserData? = nil
        if let url = URL(string: Http.baseUrl + "/auth/login") {
            let task = try Http.post(url, payload: data) { result in
                switch result {
                case .success(let responseData):
                    do {
                        userData = try JSONDecoder().decode(UserData.self, from: responseData)
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
        return userData
    }

    static func register(_ data: RegistrationData) throws -> UserData? {
        var userData: UserData? = nil
        if let url = URL(string: Http.baseUrl + "/auth/signup") {
            let task = try Http.post(url, payload: data) { result in
                switch result {
                case .success(let responseData):
                    do {
                        userData = try JSONDecoder().decode(UserData.self, from: responseData)
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
        return userData
    }
}
