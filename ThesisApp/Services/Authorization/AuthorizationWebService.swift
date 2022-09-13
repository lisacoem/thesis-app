//
//  AuthorizationWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct AuthorizationWebService: AuthorizationService {
    
    private let apiPath = "/api/v1/auth"
    
    func login(_ data: LoginData) -> AnyPublisher<AppUserData, ApiError> {
        guard let url = URL(string: apiPath + "/login", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<AppUserData, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Api.encoder.encode(data) else {
            return AnyPublisher(
                Fail<AppUserData, ApiError>(error: .invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: AppUserData.self)
    }
    
    func signup(_ data: RegistrationData) -> AnyPublisher<AppUserData, ApiError> {
        print(Api.baseUrl.absoluteURL)
        guard let url = URL(string: apiPath + "/signup", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<AppUserData, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Api.encoder.encode(data) else {
            return AnyPublisher(
                Fail<AppUserData, ApiError>(error: .invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: AppUserData.self)
    }
    
    func store(_ userData: AppUserData) {
        UserDefaults.standard.set(true, for: .isLoggedIn)
        UserDefaults.standard.set(userData.team == nil, for: .isTeamRequired)
        UserDefaults.standard.set(userData.points, for: .points)
        UserDefaults.standard.set(userData.id, for: .userId)

        Keychain.authorizationToken = userData.token
    }
}
