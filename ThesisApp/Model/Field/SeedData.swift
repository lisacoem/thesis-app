//
//  Seed.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation
import CoreData

struct SeedData: Decodable {
    
    private(set) var id: Int64
    private(set) var name: String
    private(set) var price: Int16
    private(set) var seasons: [Season]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id, name, price, seasons
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        price = try values.decode(Int16.self, forKey: .price)
        seasons = try values
            .decode([Int].self, forKey: .seasons)
            .compactMap { Season(rawValue: $0) }
    }
    
    init(
        id: Int64,
        name: String,
        price: Int16,
        seasons: [Season]
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.seasons = seasons
    }
}
