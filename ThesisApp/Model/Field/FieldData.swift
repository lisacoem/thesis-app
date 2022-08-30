//
//  FieldData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation

struct FieldData: Decodable {
    
    private(set) var id: Int64
    private(set) var name: String
    
    private(set) var street: String
    private(set) var size: Double
    
    private(set) var seeds: [SeedData]
    private(set) var plants: [PlantData]
}
