//
//  FieldData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation

struct FieldData: Decodable {
    
    var id: Int64
    var name: String
    
    var street: String
    var size: Double
    
    var seeds: [SeedData]
    var plants: [PlantData]
}
