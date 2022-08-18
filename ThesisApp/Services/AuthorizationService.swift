//
//  Authorization.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 15.08.22.
//

import Foundation
import Combine

protocol AuthorizationService {

    func login(_ data: LoginData) -> AnyPublisher<UserData, Error>
    func signup(_ data: RegistrationData) -> AnyPublisher<UserData, Error>
    
    func searchTeams(by zipcode: String) -> AnyPublisher<[TeamData], Error>

}

class WebAuthorizationService: AuthorizationService, ObservableObject {
    
    func login(_ data: LoginData) -> AnyPublisher<UserData, Error> {
        guard let url = URL(string: Http.baseUrl + "/auth/login") else {
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
            .subscribe(on: DispatchQueue(label: "SessionProcessingQueue") )
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
    
    func signup(_ data: RegistrationData) -> AnyPublisher<UserData, Error> {
        guard let url = URL(string: Http.baseUrl + "/auth/signup") else {
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
    
}
