//
//  Converter.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.08.22.
//

import CoreLocation
import SceneKit

enum Converter {
    
    static func kilometers(meters: Double) -> Double {
        meters / 1000
    }
    
    static func meters(kilometers: Double) -> Double {
        kilometers * 1000
    }
    
    static func kilometersPerHour(metersPerSecond: Double) -> Double {
        metersPerSecond * 3.6
    }
    
    static func kilometersPerHour(metersPerSecond: Double?) -> Double? {
        guard let mps = metersPerSecond else {
            return nil
        }
        return mps * 3.6
    }
    
    static func metersPerSecond(kilometersPerHour: Double) -> Double {
        kilometersPerHour / 3.6
    }
    
    static func date(string: String, format: String = "dd.MM.yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    static func radians(degrees: Float) -> Float {
        degrees * .pi / 180
    }
    
}
