//
//  TeamWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct TeamWebService: TeamService {
    
    private let apiPath: String = "/api/v1/private/team"
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], ApiError> {
        guard let url = URL(string: apiPath + "/search?q=\(zipcode)", relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<[TeamData], ApiError>(error: ApiError.invalidUrl)
            )
        }
        
        return API.get(url, receive: [TeamData].self)
    }
    
    func joinTeam(_ data: TeamData) -> AnyPublisher<TeamData, ApiError> {
        guard let url = URL(string: apiPath + "/join", relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<TeamData, ApiError>(error: ApiError.invalidUrl)
            )
        }
        
        guard let payload = try? API.encoder.encode(data) else {
            return AnyPublisher(
                Fail<TeamData, ApiError>(error: ApiError.invalidData)
            )
        }
        
        return API.post(url, payload: payload, receive: TeamData.self)
    }
    
    func getRanking() -> AnyPublisher<TeamRankingData, ApiError> {
        guard let url = URL(string: apiPath + "/ranking", relativeTo: API.baseUrl) else {
            return AnyPublisher(
                Fail<TeamRankingData, ApiError>(error: .invalidUrl)
            )
        }
        
        return API.get(url, receive: TeamRankingData.self)
    }
    
}
