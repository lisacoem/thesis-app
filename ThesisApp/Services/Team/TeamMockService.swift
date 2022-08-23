//
//  TeamMockService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct TeamMockService: TeamService {
    
    let teams: [TeamData] = [
        .init(id: 1, name: "Berlin", zipcode: "10115", userCount: 46723),
        .init(id: 2, name: "Köln", zipcode: "50670", userCount: 1542),
        .init(id: 3, name: "München", zipcode: "80335", userCount: 67143),
        .init(id: 4, name: "Wiesbaden", zipcode: "65189", userCount: 850)
    ]
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], HttpError> {
        return Just(teams.filter { $0.zipcode.starts(with: zipcode) })
            .setFailureType(to: HttpError.self)
            .eraseToAnyPublisher()
    }
    
    func joinTeam(_ data: TeamData) -> AnyPublisher<UserData, HttpError> {
        return Just(.init(
                id: 1,
                firstName: "Max",
                lastName: "Mustermann",
                role: .participant,
                points: 18,
                team: data
            ))
            .setFailureType(to: HttpError.self)
            .eraseToAnyPublisher()
    }
    
    
}
