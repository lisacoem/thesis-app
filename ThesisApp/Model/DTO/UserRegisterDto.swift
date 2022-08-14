//
//  UserRegisterDto.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 10.08.22.
//

import Foundation

class UserRegisterDto: Dto {
    
    var mail: String
    var firstName: String
    var lastName: String
    var password: String
    var role: Role
    
    init(
        mail: String,
        firstName: String,
        lastName: String,
        password: String,
        role: Role
    ) {
        self.mail = mail
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.role = role
        super.init()
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case mail, firstName, lastName, password, role
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mail = try values.decode(String.self, forKey: .mail)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        password = try values.decode(String.self, forKey: .password)
        role = Role(rawValue: try values.decode(String.self, forKey: .role))!
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mail, forKey: .mail)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encode(role.rawValue, forKey: .role)
    }
}

