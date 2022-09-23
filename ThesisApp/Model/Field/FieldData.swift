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

struct SeedData: Codable {
    private(set) var id: Int64
    private(set) var name: String
    private(set) var image: String
    private(set) var price: Int32
}

struct PlantingData: Encodable {
    private(set) var seedId: Int64
    private(set) var position: Position
}

struct PlantData: Decodable {
    private(set) var id: Int64
    
    private(set) var position: Position
    private(set) var seedingDate: Date?
    private(set) var growthPeriod: TimeInterval
    private(set) var system: LindenmayerSystemData
    
    private(set) var user: UserData
}

struct LindenmayerSystemData: Decodable {
    private(set) var name: String
    private(set) var iterations: Int16
    private(set) var length: Float
    private(set) var radius: Float
    private(set) var angle: Float

    private(set) var axiom: String
    private(set) var rules: [LindenmayerRuleData]
}

struct LindenmayerRuleData: Decodable {
    private(set) var replaceFrom: String
    private(set) var replaceTo: String
}
