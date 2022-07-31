//
//  TimeInterval+Format.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 14.07.22.
//

import Foundation

extension TimeInterval {
    
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)!
    }
    
    func seconds() -> String {
        let formatString = self.format(using: [.hour, .minute, .second])
        return String((formatString.split(separator: " ")).last!)
    }
}

