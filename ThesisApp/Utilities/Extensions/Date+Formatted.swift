//
//  Date+Formatted.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 19.08.22.
//

import Foundation

extension Date {

    var formatted: Date? {
        Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: self
            )
        )
    }
}
