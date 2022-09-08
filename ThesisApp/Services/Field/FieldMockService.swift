//
//  FieldMockService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

class FieldMockService: FieldService {
    
    func getFields() -> AnyPublisher<[FieldData], HttpError> {
        return Just(fields)
            .setFailureType(to: HttpError.self)
            .eraseToAnyPublisher()
    }
    
    func getWeather() -> AnyPublisher<WeatherData, HttpError> {
        return Just(
            WeatherData(
                weather: Weather.allCases.randomElement(),
                daytime: Daytime.allCases.randomElement()
            ))
            .setFailureType(to: HttpError.self)
            .eraseToAnyPublisher()
    }
    
    func createPlant(_ data: PlantingRequestData) -> AnyPublisher<PlantingResponseData, HttpError> {
        guard
            var fieldData = fields.filter({ $0.id == data.fieldId }).first,
            let seedData = fieldData.seeds.filter({ $0.id == data.seedId }).first
        else {
            return AnyPublisher(
                Fail<PlantingResponseData, HttpError>(error: .invalidData)
            )
        }
        
        fieldData.plants.append(
            .init(
                id: Int64(fieldData.plants.count),
                name: seedData.name,
                plantingDate: .now,
                growthPeriod: 0,
                user: .init(
                    id: 0,
                    firstName: "Max",
                    lastName: "Mustermann"
                )
            )
        )
        
        return Just(.init(
                field: fieldData,
                points: 0
            ))
            .setFailureType(to: HttpError.self)
            .eraseToAnyPublisher()
    }
    
    let fields = [
        FieldData(
            id: 1,
            name: "Biohof Günther",
            street: "Außerhalb 2",
            size: 25,
            seeds: [
                .init(
                    id: 0,
                    name: "Wirsing",
                    price: 25
                ),
                .init(
                    id: 1,
                    name: "Rotkohl",
                    price: 0
                ),
                .init(
                    id: 2,
                    name: "Brokkoli",
                    price: 30
                ),
                .init(
                    id: 3,
                    name: "Kohlrabi",
                    price: 30
                )
            ],
            plants: []
        )
    ]
}
