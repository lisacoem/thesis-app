//
//  PlantData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation

struct PlantData: Decodable {
    
    var id: Int64
    var name: String
    
    var plantingDate: Date
    var growthPeriod: TimeInterval
    
    var user: UserData
}
