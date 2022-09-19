//
//  AchievementData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.09.22.
//

import Foundation

struct Achieved<T: Decodable>: Decodable {
    private(set) var points: Double
    private(set) var data: T
    private(set) var achievements: [AchievementData]
}

struct AchievementData: Decodable {
    private(set) var id: Int64
    private(set) var title: String
    private(set) var content: String
    private(set) var image: String?
    private(set) var goal: Double
    private(set) var unlocked: Bool
}
