//
//  TeamData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

class TeamData: AnyCodable {
    
    var id: Int64
    var name: String
    var zipcode: String
    var userCount: Int
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name, zipcode, userCount
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        zipcode = try values.decode(String.self, forKey: .zipcode)
        name = try values.decode(String.self, forKey: .name)
        userCount = try values.decode(Int.self, forKey: .userCount)
        super.init()
    }
    
    init(
        id: Int64,
        name: String,
        zipcode: String,
        userCount: Int
    ) {
        self.id = id
        self.name = name
        self.zipcode = zipcode
        self.userCount = userCount
        super.init()
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(zipcode, forKey: .zipcode)
        try container.encode(userCount, forKey: .userCount)
    }
}
