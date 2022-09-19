//
//  TeamMockService.swift
//  ThesisApp
//
//  Mock Service Implementation for Preview
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct TeamMockService: TeamService {
    
    let teams: [TeamData] = [
        .init(id: 1, name: "Berlin", description: "10115", userCount: 46723),
        .init(id: 2, name: "Köln", description: "50670", userCount: 1542),
        .init(id: 3, name: "München", description: "80335", userCount: 67143),
        .init(id: 4, name: "Wiesbaden", description: "65189", userCount: 850)
    ]
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], ApiError> {
        return Just(teams.filter { $0.description.starts(with: zipcode) })
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func joinTeam(_ data: TeamData) -> AnyPublisher<TeamData, ApiError> {
        return Just(data)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func getRanking() -> AnyPublisher<TeamRankingData, ApiError> {
        return Just(TeamRankingData(
                team: .init(id: 4, name: "Wiesbaden", description: "65189", distance: 9235.12, rank: 4),
                ranking: [
                    .init(id: 1,name: "Berlin", description: "10115", distance: 124323.32, rank: 1),
                    .init(id: 2, name: "Köln", description: "50670", distance: 10167.99, rank: 2),
                    .init(id: 3, name: "München", description: "80335", distance: 9761.84, rank: 3),
                    .init(id: 4, name: "Wiesbaden", description: "65189", distance: 9235.12, rank: 4)
                ]
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    
    
}
