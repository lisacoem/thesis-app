//
//  TeamWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct TeamWebService: TeamService {
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/team/search?q=\(zipcode)") else {
            return AnyPublisher(
                Fail<[TeamData], HttpError>(error: HttpError.invalidUrl)
            )
        }
        
        return Http.request(url, method: .get, receive: [TeamData].self)
    }
    
    func joinTeam(_ data: TeamData) -> AnyPublisher<TeamData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/team/join") else {
            return AnyPublisher(
                Fail<TeamData, HttpError>(error: HttpError.invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<TeamData, HttpError>(error: HttpError.invalidData)
            )
        }
        
        return Http.request(url, method: .post, payload: payload, receive: TeamData.self)
    }
    
    func getRanking() -> AnyPublisher<TeamRankingData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/team/ranking") else {
            return AnyPublisher(
                Fail<TeamRankingData, HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.request(url, method: .get, receive: TeamRankingData.self)
    }
    
}
