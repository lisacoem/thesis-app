//
//  Dto.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.09.22.
//

import Foundation

struct FieldData: Decodable {
    private(set) var id: Int64
    private(set) var name: String
    
    private(set) var street: String
    
    private(set) var size: Double
    private(set) var rows: Int32
    private(set) var columns: Int32
    
    var seeds: [SeedData]
    var plants: [PlantData]
}

struct PlantData: Decodable {
    private(set) var id: Int64
    private(set) var name: String
    
    private(set) var position: Position

    private(set) var seedingDate: Date?
    private(set) var growthPeriod: TimeInterval
    
    private(set) var user: UserData
}

struct SeedData: Codable {
    private(set) var id: Int64
    private(set) var name: String
    private(set) var image: String
    private(set) var price: Int32
}

struct PlantingData: Encodable {
    private(set) var fieldId: Int64
    private(set) var seedId: Int64
    private(set) var position: Position
}
