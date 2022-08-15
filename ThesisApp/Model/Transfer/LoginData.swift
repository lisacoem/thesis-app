//
//  LoginData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

class LoginData: AnyCodable {
    
    var mail: String
    var password: String
    
    init(mail: String, password: String) {
        self.mail = mail
        self.password = password
        super.init()
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case mail, password
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mail = try values.decode(String.self, forKey: .mail)
        password = try values.decode(String.self, forKey: .password)
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mail, forKey: .mail)
        try container.encode(password, forKey: .password)
    }
}
