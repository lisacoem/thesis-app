//
//  FieldService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

protocol FieldService {
    
    func getFields() -> AnyPublisher<[FieldData], HttpError>
    func getWeather() -> AnyPublisher<WeatherData, HttpError>
    
    func createPlant(_ data: PlantingRequestData) -> AnyPublisher<PlantingResponseData, HttpError>

}
