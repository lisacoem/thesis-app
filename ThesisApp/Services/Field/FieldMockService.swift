//
//  FieldMockService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 26.08.22.
//

import Foundation
import Combine

class FieldMockService: FieldService {
    
    func getFields() -> AnyPublisher<[FieldData], ApiError> {
        return Just(fields)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func getWeather() -> AnyPublisher<WeatherData, ApiError> {
        return Just(
            WeatherData(
                weather: Weather.allCases.randomElement(),
                daytime: Daytime.allCases.randomElement()
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func createPlant(_ data: PlantingData) -> AnyPublisher<Achieved<FieldData>, ApiError> {
        guard
            var fieldData = fields.filter({ $0.id == data.fieldId }).first,
            let seedData = fieldData.seeds.filter({ $0.id == data.seedId }).first
        else {
            return AnyPublisher(
                Fail<Achieved<FieldData>, ApiError>(error: .invalidData)
            )
        }
        
        fieldData.plants.append(
            .init(
                id: Int64(fieldData.plants.count),
                name: seedData.name,
                row: data.row,
                column: data.column,
                plantingDate: .now,
                growthPeriod: 0,
                user: .init(
                    id: 0,
                    firstName: "Max",
                    lastName: "Mustermann"
                )
            )
        )
        
        return Just(
            .init(
                points: 0,
                data: fieldData,
                achievements: []
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    let fields = [
        FieldData(
            id: 1,
            name: "Biohof Günther",
            street: "Außerhalb 2",
            size: 100,
            rows: 10,
            columns: 10,
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
