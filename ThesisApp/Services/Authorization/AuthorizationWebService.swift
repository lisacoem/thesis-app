//
//  AuthorizationWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct AuthorizationWebService: AuthorizationService {
    
    func login(_ data: LoginData) -> AnyPublisher<UserData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/auth/login") else {
            return AnyPublisher(
                Fail<UserData, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<UserData, HttpError>(error: .invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: UserData.self)
    }
    
    func signup(_ data: RegistrationData) -> AnyPublisher<UserData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/auth/signup") else {
            return AnyPublisher(
                Fail<UserData, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<UserData, HttpError>(error: .invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: UserData.self)
    }
    
}
