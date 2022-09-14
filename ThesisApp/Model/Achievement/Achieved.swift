//
//  Achieved.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 13.09.22.
//

import Foundation

struct Achieved<T: Decodable>: Decodable {
    private(set) var points: Double
    private(set) var data: T
    private(set) var achievements: [AchievementData]
}
