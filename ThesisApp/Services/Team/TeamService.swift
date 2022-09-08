//
//  TeamService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

protocol TeamService {
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], HttpError>
    func joinTeam(_ data: TeamData) -> AnyPublisher<TeamData, HttpError>
    
    func getRanking() -> AnyPublisher<TeamRankingData, HttpError>
    
}
