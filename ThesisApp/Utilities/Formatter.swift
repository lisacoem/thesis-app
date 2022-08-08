//
//  Formatter.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.08.22.
//

import Foundation

struct Formatter {
    
    static func date(_ date: Date, format: String = "dd.MM.yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func double(_ double: Double, unit: String? = nil) -> String {
        if let unit = unit {
            return "\(double.toString()) \(unit)"
        }
        return double.toString()
    }
    
    static func time(_ timeInterval: TimeInterval, units: NSCalendar.Unit = [.hour, .minute]) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: timeInterval)!
    }
    
    static func seconds(_ timeInterval: TimeInterval) -> String {
        let time = self.time(timeInterval, units: [.hour, .minute, .second])
        return String((time.split(separator: " ")).last!)
    }
}
