//
//  Movement.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 12.07.22.
//

public enum Movement: String, CaseIterable, Codable {
    case cycling = "CYCLING",
         walking = "WALKING"
    
    func values() -> (name: String, symbol: String, minSpeed: Double, maxSpeed: Double) {
        switch self {
        case .cycling:
            return ("Radfahren", "bicycle", 7, 45)
        case .walking:
            return ("Spazieren", "figure.walk", 1, 10)
        }
    }
}

extension Movement: Identifiable {
    
    public var id: String { rawValue }
}

extension Movement {
    
    func isValid(speed: Double) -> Bool {
        return speed >= self.values().minSpeed && speed <= self.values().maxSpeed
    }
}
