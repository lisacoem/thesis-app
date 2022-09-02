//
//  Seed.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation
import CoreData

struct SeedData: Codable {
    
    private(set) var id: Int64
    private(set) var name: String
    private(set) var price: Int32
    
    init(_ seed: Seed) {
        self.id = seed.id
        self.name = seed.name
        self.price = seed.price
    }
    
    init(
        id: Int64,
        name: String,
        price: Int32
    ) {
        self.id = id
        self.name = name
        self.price = price
    }

}
