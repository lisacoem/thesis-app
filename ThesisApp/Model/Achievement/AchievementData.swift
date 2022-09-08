//
//  AchievementData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 08.09.22.
//

import Foundation

struct TeamResultData: Codable, Identifiable, Comparable {
    private(set) var id: Int64
    private(set) var name: String
    private(set) var description: String
    private(set) var distance: Double
    private(set) var rank: Int?
    
    static func < (lhs: TeamResultData, rhs: TeamResultData) -> Bool {
        if let lhsRank = lhs.rank {
            if let rhsRank = rhs.rank {
                return lhsRank < rhsRank
            }
            return false
        }
        if rhs.rank != nil {
            return true
        }
        return lhs.name < rhs.name
    }
}

struct TeamRankingData: Codable {
    private(set) var team: TeamResultData?
    private(set) var ranking: [TeamResultData]
}
