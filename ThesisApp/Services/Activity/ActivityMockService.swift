//
//  ActivityMockService.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 18.08.22.
//

import Foundation
import Combine
import CoreData

class ActivityMockService: ActivityService {
    
    var activities: [ActivityData] = [
        .init(
            movement: .cycling,
            distance: 35.75,
            duration: 60 * 60,
            date: Converter.date(string: "08.08.2022")!,
            track: []
        ),
        .init(
            movement: .walking,
            distance: 3.89,
            duration: 60 * 60 * 4,
            date: Converter.date(string: "12.8.2022")!,
            track: []
        )
    ]
    
    private var versionToken: String? = nil
    
    func importActivities() -> AnyPublisher<ActivityListData, ApiError> {
        return Just(.init(
                activities: activities,
                versionToken: self.versionToken
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<Achieved<ActivityListData>, ApiError> {
        self.activities.append(contentsOf: activities)
        return Just(.init(
                points: 0,
                data: .init(
                    activities: activities,
                    versionToken: self.versionToken
                ),
                achievements: []
            ))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
}
