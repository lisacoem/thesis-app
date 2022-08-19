//
//  UserData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation
import CoreData


struct LoginData: Encodable {
    
    var mail: String
    var password: String
    
}

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


struct UserData: Codable {
    
    var id: Int64
    var firstName: String
    var lastName: String
    var role: Role
    var token: String?
    var points: Double
    var team: TeamData?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, firstName, lastName, role, token, points, team
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        role = Role(rawValue: try values.decode(String.self, forKey: .role))!
        points = try values.decode(Double.self, forKey: .points)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        team = try values.decodeIfPresent(TeamData.self, forKey: .team)
    }
    
    init(
        id: Int64,
        firstName: String,
        lastName: String,
        role: Role,
        token: String? = nil,
        points: Double,
        team: TeamData? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.token = token
        self.points = points
        self.team = team
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(role.rawValue, forKey: .role)
        try container.encode(points, forKey: .points)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(team, forKey: .team)
    }
}
