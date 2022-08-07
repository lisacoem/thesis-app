//
//  Movement.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

public enum Movement: String, CaseIterable {
    case Cycling = "CYCLING",
        Walking = "WALKING"
    
    var info: MovementInfo {
        switch self {
        case .Cycling:
            return .init(name: "Radfahren", symbol: "bicycle", kilometersPerHour: 40)
        case .Walking:
            return .init(name: "Spazieren", symbol: "figure.walk", kilometersPerHour: 6)
        }
    }
    
    var name: String { info.name }
    var symbol: String { info.symbol }
    var kilometersPerHour: Double { info.kilometersPerHour }
}

struct MovementInfo {
    var name: String
    var symbol: String
    var kilometersPerHour: Double
}
