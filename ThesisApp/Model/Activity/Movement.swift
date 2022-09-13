//
//  Movement.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.07.22.
//

public enum Movement: String, CaseIterable, Codable {
    case cycling = "CYCLING",
         walking = "WALKING"
    
    var info: MovementInfo {
        switch self {
        case .cycling:
            return .init(name: "Radfahren", symbol: "bicycle", minSpeed: 7, maxSpeed: 45)
        case .walking:
            return .init(name: "Spazieren", symbol: "figure.walk", minSpeed: 1, maxSpeed: 10)
        }
    }
    
    var name: String { info.name }
    var symbol: String { info.symbol }
    var minSpeed: Double { info.minSpeed }
    var maxSpeed: Double { info.maxSpeed }
}

struct MovementInfo {
    var name: String
    var symbol: String
    var minSpeed: Double
    var maxSpeed: Double
}
