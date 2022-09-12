//
//  TeamService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

protocol TeamService {
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], ApiError>
    func joinTeam(_ data: TeamData) -> AnyPublisher<TeamData, ApiError>
    
    func getRanking() -> AnyPublisher<TeamRankingData, ApiError>
    
}
