//
//  Converters.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.08.22.
//

import Foundation

struct Converters {
    
    static func kilometers(meters: Double) -> Double {
        meters / 1000
    }
    
    static func meters(kilometers: Double) -> Double {
        kilometers * 1000
    }
    
    static func kilometersPerHour(metersPerSecond: Double) -> Double {
        metersPerSecond * 3.6
    }
    
    static func metersPerSecond(kilometersPerHour: Double) -> Double {
        kilometersPerHour / 3.6
    }
}
