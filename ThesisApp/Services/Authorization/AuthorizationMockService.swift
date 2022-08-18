//
//  AuthorizationMockService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct AuthorizationMockService: AuthorizationService {
    func login(_ data: LoginData) -> AnyPublisher<UserData, Error> {
        return Just(.init(
                id: 1,
                firstName: "Max",
                lastName: "Mustermann",
                role: .participant,
                points: 18
            ))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func signup(_ data: RegistrationData) -> AnyPublisher<UserData, Error> {
        return Just(.init(
                id: 1,
                firstName: "Max",
                lastName: "Mustermann",
                role: .participant,
                points: 18
            ))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
