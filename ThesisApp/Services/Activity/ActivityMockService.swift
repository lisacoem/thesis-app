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
    
    func importActivities() -> AnyPublisher<PointData<[ActivityData]>, HttpError> {
        return Just(.init(
                points: 0,
                data: activities,
                versionToken: self.versionToken
            ))
            .setFailureType(to: HttpError.self)
            .eraseToAnyPublisher()
    }
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<PointData<[ActivityData]>, HttpError> {
        self.activities.append(contentsOf: activities)
        return Just(.init(
                points: 0,
                data: activities,
                versionToken: self.versionToken
            ))
            .setFailureType(to: HttpError.self)
            .eraseToAnyPublisher()
    }
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<PointData<[ActivityData]>, HttpError> {
        guard self.versionToken != nil else {
            return self.importActivities()
        }

        let request = Activity.fetchRequest(NSPredicate(format: "version = nil"))
        
        if let activities = try? context.fetch(request), !activities.isEmpty {
            return self.saveActivities(activities.map { ActivityData($0) })
        }
    
        return AnyPublisher(
            Fail<PointData<[ActivityData]>, HttpError>(error: .invalidData)
        )
    }
    
    
}
