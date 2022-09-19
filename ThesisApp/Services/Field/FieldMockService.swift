//
//  FieldMockService.swift
//  ThesisApp
//
//  Mock Service Implementation for Preview
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
            let seedData = fields.flatMap({ $0.seeds }).filter({ $0.id == data.seedId }).first,
            var fieldData = fields.filter({ !$0.seeds.filter({ $0.id == data.seedId }).isEmpty }).first
        else {
            return AnyPublisher(
                Fail<Achieved<FieldData>, ApiError>(error: .invalidData)
            )
        }
        
        fieldData.plants.append(
            .init(
                id: Int64(fields.flatMap({ $0.plants }).count + 1),
                name: seedData.name,
                position: data.position,
                seedingDate: .now,
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
                    image: "/images/seeds/wirsing.png",
                    price: 25
                ),
                .init(
                    id: 1,
                    name: "Rotkohl",
                    image: "/images/seeds/rotkohl.png",
                    price: 0
                ),
                .init(
                    id: 2,
                    name: "Brokkoli",
                    image: "/images/seeds/brokkoli.png",
                    price: 30
                ),
                .init(
                    id: 3,
                    name: "Kohlrabi",
                    image: "/images/seeds/kohlrabi.png",
                    price: 30
                )
            ],
            plants: [
                .init(
                    id: 0,
                    name: "Brokkoli",
                    position: .init(row: 3, column: 5),
                    seedingDate: .now,
                    growthPeriod: 1000,
                    user: .init(
                        id: 100,
                        firstName: "Lisa",
                        lastName: "Test"
                    )
                )
            ]
        )
    ]
}
