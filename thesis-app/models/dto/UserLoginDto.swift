//
//  UserLoginDto.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

public struct UserLoginDto {
    var mail: String
    var password: String
}

extension UserLoginDto: Encodable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case mail, password
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(mail, forKey: .mail)
        try container.encode(password, forKey: .password)
    }
}
