//
//  TeamData.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation

struct TeamData: Codable {
    
    var id: Int64
    var name: String
    var zipcode: String
    var userCount: Int
}

struct TeamResult: Decodable, Identifiable, Comparable {
    
    var id: Int64
    var name: String
    var zipcode: String
    var distance: Double
    var rank: Int
    
    static func < (lhs: TeamResult, rhs: TeamResult) -> Bool {
        lhs.rank < rhs.rank
    }
}

struct TeamRanking: Decodable {
    
    var team: TeamResult?
    var ranking: [TeamResult]
}
