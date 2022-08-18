//
//  Authorization.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation
import Combine

protocol AuthorizationService {

    func login(_ data: LoginData) -> AnyPublisher<UserData, Error>
    func signup(_ data: RegistrationData) -> AnyPublisher<UserData, Error>

}
