//
//  PlantData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation

struct PlantData: Decodable {
    
    private(set) var id: Int64
    private(set) var name: String
    
    private(set) var plantingDate: Date
    private(set) var growthPeriod: TimeInterval
    
    private(set) var user: UserData
}
