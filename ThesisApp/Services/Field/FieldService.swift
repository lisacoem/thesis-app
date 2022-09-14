//
//  FieldService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

protocol FieldService {
    
    func getFields() -> AnyPublisher<[FieldData], ApiError>
    func getWeather() -> AnyPublisher<WeatherData, ApiError>
    
    func createPlant(_ data: PlantingData) -> AnyPublisher<Achieved<FieldData>, ApiError>

}
