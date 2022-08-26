//
//  RegistrationData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation

struct RegistrationData: Encodable {
    
    var mail: String
    var firstName: String
    var lastName: String
    var password: String
    var role: Role
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case mail, firstName, lastName, password, role
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mail, forKey: .mail)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encode(role.rawValue, forKey: .role)
    }
}
