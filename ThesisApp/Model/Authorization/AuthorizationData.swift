//
//  Dto.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.09.22.
//

import Foundation

struct RegistrationData: Encodable {
    private(set) var mail: String
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var password: String
}

struct LoginData: Encodable {
    private(set) var mail: String
    private(set) var password: String
}

struct AppUserData: Decodable {
    private(set) var id: Int64
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var points: Double
    private(set) var team: TeamData?
    private(set) var token: String?
}

