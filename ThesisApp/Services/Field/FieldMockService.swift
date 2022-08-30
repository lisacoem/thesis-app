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
    
    func getDaytime() -> AnyPublisher<Daytime, HttpError> {
        return Just(Daytime.allCases.randomElement()!)
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
                    price: 25,
                    seasons: [.august, .september]
                ),
                .init(
                    id: 1,
                    name: "Rotkohl",
                    price: 0,
                    seasons: [.august, .september]
                ),
                .init(
                    id: 2,
                    name: "Brokkoli",
                    price: 30,
                    seasons: [.august, .september]
                ),
                .init(
                    id: 3,
                    name: "Kohlrabi",
                    price: 30,
                    seasons: [.august, .september]
                )
            ],
            plants: []
        )
    ]
}
