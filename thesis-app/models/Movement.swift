//
//  Movement.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

public enum Movement: String, CaseIterable {
    case Cycling = "Radfahren",
        Walking = "Spazieren"
    
    var name: String { rawValue }
    
    var icon: String {
        switch(self) {
        case .Cycling:
            return "bicycle"
        case .Walking:
            return "figure.walk"
        }
    }
}
