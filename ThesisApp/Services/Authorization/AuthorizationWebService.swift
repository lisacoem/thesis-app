//
//  AuthorizationWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct AuthorizationWebService: AuthorizationService {
    
    func login(_ data: LoginData) -> AnyPublisher<AppUserData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/auth/login") else {
            return AnyPublisher(
                Fail<AppUserData, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<AppUserData, HttpError>(error: .invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: AppUserData.self)
    }
    
    func signup(_ data: RegistrationData) -> AnyPublisher<AppUserData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/auth/signup") else {
            return AnyPublisher(
                Fail<AppUserData, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<AppUserData, HttpError>(error: .invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: AppUserData.self)
    }
    
    func store(_ userData: AppUserData) {
        UserDefaults.standard.set(true, for: .isLoggedIn)
        UserDefaults.standard.set(userData.team == nil, for: .isTeamRequired)
        UserDefaults.standard.set(userData.points, for: .points)

        Keychain.authorizationToken = userData.token
    }
}
