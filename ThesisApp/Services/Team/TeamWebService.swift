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
        guard let url = URL(string: Http.baseUrl + "/team/search?q=\(zipcode)") else {
            return AnyPublisher(
                Fail<[TeamData], HttpError>(error: HttpError.invalidUrl)
            )
        }
        
        return Http.get(url, receive: [TeamData].self)
    }
    
    func joinTeam(_ data: TeamData) -> AnyPublisher<TeamData, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/team/join") else {
            return AnyPublisher(
                Fail<TeamData, HttpError>(error: HttpError.invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<TeamData, HttpError>(error: HttpError.invalidData)
            )
        }
        
        return Http.post(url, payload: payload, receive: TeamData.self)
    }
    
    func getRanking() -> AnyPublisher<TeamRanking, HttpError> {
        guard let url = URL(string: Http.baseUrl + "/team/ranking") else {
            return AnyPublisher(
                Fail<TeamRanking, HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.get(url, receive: TeamRanking.self)
    }
    
}
