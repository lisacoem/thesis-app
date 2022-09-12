//
//  AuthorizationMockService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct AuthorizationMockService: AuthorizationService {
    
    func login(_ data: LoginData) -> AnyPublisher<AppUserData, ApiError> {
        return Just(.init(
                id: 0,
                firstName: "Max",
                lastName: "Mustermann",
                points: 18
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func signup(_ data: RegistrationData) -> AnyPublisher<AppUserData, ApiError> {
        return Just(.init(
                id: 1,
                firstName: data.firstName,
                lastName: data.lastName,
                points: 0
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func store(_ userData: AppUserData) {}
}
