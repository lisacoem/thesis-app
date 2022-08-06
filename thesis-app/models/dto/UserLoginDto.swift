//
//  UserLoginDto.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

public struct UserLoginDto {
    var email: String
    var password: String
}

extension UserLoginDto: Encodable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case email, password
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
}
