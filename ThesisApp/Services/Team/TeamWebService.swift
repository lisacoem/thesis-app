//
//  TeamWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine

struct TeamWebService: TeamService {
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], Error> {
        guard let url = URL(string: Http.baseUrl + "/team/search?q=\(zipcode)") else {
            return AnyPublisher(
                Fail<[TeamData], Error>(error: HttpError.invalidUrl)
            )
        }
        
        return Http.get(url)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw HttpError.serverError
                }
                return output.data
            }
            .decode(type: [TeamData].self, decoder: JSONDecoder())
            .mapError { error in
                HttpError.invalidData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func joinTeam(_ data: TeamData) -> AnyPublisher<UserData, Error> {
        guard let url = URL(string: Http.baseUrl + "/team/join") else {
            return AnyPublisher(
                Fail<UserData, Error>(error: HttpError.invalidUrl)
            )
        }
        
        let encoder = JSONEncoder()
        guard let payload = try? encoder.encode(data) else {
            return AnyPublisher(
                Fail<UserData, Error>(error: HttpError.invalidData)
            )
        }
        
        return Http.post(url, payload: payload)
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue"))
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw HttpError.serverError
                }
                return output.data
            }
            .decode(type: UserData.self, decoder: JSONDecoder())
            .mapError { error in
                HttpError.invalidData
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
