//
//  FieldWebService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

class FieldWebService: FieldService {
    
    private let apiPath: String = "/api/v1/private/fields"
    
    func getFields() -> AnyPublisher<[FieldData], ApiError> {
        guard let url = URL(string: apiPath, relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<[FieldData], ApiError>(error: .invalidUrl)
            )
        }
        
        return Api.get(url, receive: [FieldData].self)
    }
    
    func getWeather() -> AnyPublisher<WeatherData, ApiError> {
        guard let url = URL(string: apiPath + "/weather", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<WeatherData, ApiError>(error: .invalidUrl)
            )
        }
        
        return Api.get(url, receive: WeatherData.self)
    }
    
    func createPlant(_ data: PlantingRequestData) -> AnyPublisher<PlantingResponseData, ApiError> {
        guard let url = URL(string: apiPath + "/plant", relativeTo: Api.baseUrl) else {
            return AnyPublisher(
                Fail<PlantingResponseData, ApiError>(error: .invalidUrl)
            )
        }
        
        guard let payload = try? Api.encoder.encode(data) else {
            return AnyPublisher(
                Fail<PlantingResponseData, ApiError>(error: ApiError.invalidData)
            )
        }
        
        return Api.post(url, payload: payload, receive: PlantingResponseData.self)
    }
    
}
