//
//  UserRegisterDto.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

public enum UserRoleDto: String, CaseIterable {
    case Participant = "PARTICIPANT", Contractor = "CONTRACTOR"
}

public struct UserDto {
    var mail: String
    var firstName: String
    var lastName: String
    var password: String?
    var role: UserRoleDto
}

extension UserDto: Decodable, Encodable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case mail, firstName, lastName, password, role
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mail = try values.decode(String.self, forKey: .mail)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        role = UserRoleDto(rawValue: try values.decode(String.self, forKey: .role))!
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mail, forKey: .mail)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encode(role.rawValue, forKey: .role)
    }
}

