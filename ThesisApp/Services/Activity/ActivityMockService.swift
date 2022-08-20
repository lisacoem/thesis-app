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
            distance: 35,
            duration: 60 * 60,
            date: .now,
            track: []
        )
    ]
    
    var versionToken: String? = nil
    
    func setVersionToken(_ versionToken: String?) {
        self.versionToken = versionToken
    }
    
    func importActivities() -> AnyPublisher<ListData<ActivityData>, Error> {
        return Just(.init(
                data: activities,
                versionToken: self.versionToken
            ))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func saveActivities(_ activities: [ActivityData]) -> AnyPublisher<ListData<ActivityData>, Error> {
        self.activities.append(contentsOf: activities)
        return Just(.init(
                data: activities,
                versionToken: self.versionToken
            ))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func syncActivities(from context: NSManagedObjectContext) -> AnyPublisher<ListData<ActivityData>, Error> {
        guard self.versionToken != nil else {
            return self.importActivities()
        }

        let request = Activity.fetchRequest(NSPredicate(format: "version = nil"))
        
        if let activities = try? context.fetch(request), !activities.isEmpty {
            return self.saveActivities(activities.map { ActivityData($0) })
        }
    
        return AnyPublisher(Fail<ListData<ActivityData>, Error>(error: HttpError.invalidData))
    }
    
    
}
