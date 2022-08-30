//
//  TeamData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

struct TeamData: Codable {
    
    private(set) var id: Int64
    private(set) var name: String
    private(set) var zipcode: String
    private(set) var userCount: Int
}

struct TeamResult: Decodable, Identifiable, Comparable {
    
    private(set) var id: Int64
    private(set) var name: String
    private(set) var zipcode: String
    private(set) var distance: Double
    private(set) var rank: Int
    
    static func < (lhs: TeamResult, rhs: TeamResult) -> Bool {
        lhs.rank < rhs.rank
    }
}

struct TeamRanking: Decodable {
    
    private(set) var team: TeamResult?
    private(set) var ranking: [TeamResult]
}
