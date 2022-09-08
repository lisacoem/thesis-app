//
//  FieldWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

class FieldWebService: FieldService {
    
    func getFields() -> AnyPublisher<[FieldData], HttpError> {
        guard let url = URL(string: Http.baseUrl + "/private/fields") else {
            return AnyPublisher(
                Fail<[FieldData], HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.request(url, method: .get, receive: [FieldData].self)
    }
    
    func getWeather() -> AnyPublisher<WeatherData, HttpError> {
        guard let url = URL(string: "\(Http.baseUrl)/private/fields/weather") else {
            return AnyPublisher(
                Fail<WeatherData, HttpError>(error: .invalidUrl)
            )
        }
        
        return Http.request(url, method: .get, receive: WeatherData.self)
    }
    
    func createPlant(_ data: PlantingRequestData) -> AnyPublisher<PlantingResponseData, HttpError> {
        guard let url = URL(string: "\(Http.baseUrl)/private/fields/plant") else {
            return AnyPublisher(
                Fail<PlantingResponseData, HttpError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Http.encoder.encode(data) else {
            return AnyPublisher(
                Fail<PlantingResponseData, HttpError>(error: HttpError.invalidData)
            )
        }
        
        return Http.request(url, method: .get, payload: payload, receive: PlantingResponseData.self)
    }
    
}
